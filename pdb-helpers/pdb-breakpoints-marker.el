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

(defun pdb-breakpoints-marker-add-marker (file line))
(defun pdb-breakpoints-marker-remove-marker (file line))
