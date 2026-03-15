(add-to-list 'load-path (file-name-directory load-file-name))
(require 'utils)
(defun preview-color-at-cursor ()
  (interactive)
  (let ((str-cursor (get-str-word-at-cursor)))
    (if (is-hex-code (car str-cursor))
        (add-color-mark
         (car str-cursor) (cadr str-cursor) (caddr str-cursor)))))

(defun clear-color-previews ()
  (interactive)
  (clear-buffer-color-marks))

(provide 'color-preview-modes)
