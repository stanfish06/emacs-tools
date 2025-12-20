(define-minor-mode pdb-breakpoints-marker-mode
  "show breakpointss when using pdb"
  :lighter " pdb-bp"
  :global t
  (if pdb-breakpoints-marker-mode
	  (pdb-breakpoints-marker-mode-enable)
	(pdb-breakpoints-marker-mode-disable)))

(defun pdb-breakpoints-marker-mode-enable ()
  (advice-add 'gud-pdb-marker-filter :around #'pdb-breakpoints-marker-main))

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
