(define-minor-mode pdb-breakpoints-marker-mode
  "show breakpointss when using pdb"
  :lighter " pdb-bp"
  :global
  t
  (if pdb-breakpoints-marker-mode
      (pdb-breakpoints-marker-mode-enable)
    (pdb-breakpoints-marker-mode-disable)))

(defun pdb-breakpoints-marker-mode-enable ()
  (advice-add
   'gud-pdb-marker-filter
   :around #'pdb-breakpoints-marker-main))

(defun pdb-breakpoints-marker-mode-disable ()
  (advice-remove 'gud-pdb-marker-filter #'pdb-breakpoints-marker-main)
  (pdb-breakpoints-marker-clearall))

;; store file and position of breakpoint
(defvar pdb-breakpoints-marker-breakpoints '())
;; store ui markers
(defvar pdb-breakpoints-marker-markers '())

(defun pdb-breakpoints-marker-clearall ()
  (dolist (entry pdb-breakpoints-marker-markers)
    (delete-overlay (cdr entry)))
  (setq pdb-breakpoints-marker-breakpoints '())
  (setq pdb-breakpoints-marker-markers '()))

(defun pdb-breakpoints-marker-add-breakpoint (file line)
  (let ((bp (cons file (string-to-number line))))
    (unless (member bp pdb-breakpoints-marker-breakpoints)
      (push bp pdb-breakpoints-marker-breakpoints)
      (pdb-breakpoints-marker-add-marker
       file (string-to-number line)))))
(defun pdb-breakpoints-marker-remove-breakpoint (file line)
  (let ((bp (cons file (string-to-number line))))
    (setq pdb-breakpoints-marker-breakpoints
          (delete bp pdb-breakpoints-marker-breakpoints))
    (pdb-breakpoints-marker-remove-marker
     file (string-to-number line))))

(defface pdb-breakpoints-marker-marker-face '((t :foreground "red")))

(defun pdb-breakpoints-marker-add-marker (file line)
  (let ((buffer (find-file-noselect file)))
    (with-current-buffer buffer
      (save-excursion
        (goto-char (point-min))
        (forward-line (1- line))
        (let ((ov (make-overlay (point) (point))))
          (overlay-put
           ov 'before-string
           (propertize
            "BP"
            'display
            '(left-fringe
              filled-square pdb-breakpoints-marker-marker-face)))
          (push (cons (cons file line) ov)
                pdb-breakpoints-marker-markers))))))
(defun pdb-breakpoints-marker-remove-marker (file line)
  (let* ((key (cons file line))
         (entry (assoc key pdb-breakpoints-marker-markers)))
    (when entry
      (delete-overlay (cdr entry))
      (setq pdb-breakpoints-marker-markers
            (delete entry pdb-breakpoints-marker-markers)))))

(defun pdb-breakpoints-marker-main (orig-fun string)
  (let ((pos 0))
    (while (string-match
            "Breakpoint \\([0-9]+\\) at \\(.+\\):\\([0-9]+\\)" string
            pos)
      (pdb-breakpoints-marker-add-breakpoint
       (match-string 2 string) (match-string 3 string))
      (setq pos (match-end 0))))
  (let ((pos 0))
    (while (string-match
            "Deleted breakpoint \\([0-9]+\\) at \\(.+\\):\\([0-9]+\\)"
            string
            pos)
      (pdb-breakpoints-marker-remove-breakpoint
       (match-string 2 string) (match-string 3 string))
      (setq pos (match-end 0))))
  (funcall orig-fun string))
