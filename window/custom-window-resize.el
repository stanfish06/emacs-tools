(defun window-resize-mode()
	"resize window"
	(interactive)
	(message "resize with arrow key, any other key to exit")
    (let ((resize-mode-on t))
      (while resize-mode-on
        (let ((key-pressed (read-key)))
          (cond
           ((eq key-pressed 'up)
            (enlarge-window 5))
           ((eq key-pressed 'down)
            (shrink-window 5))
           ((eq key-pressed 'left)
            (shrink-window-horizontally 5))
           ((eq key-pressed 'right)
            (enlarge-window-horizontally 5))
           (t
            (setq resize-mode-on nil)))))))

(provide 'custom-window-resize)
