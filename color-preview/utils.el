;; this function returns word at curret cursor if it is a string, otherwise return nil 
;; return nil if cursor sitting on quotes
(defun get-str-word-at-cursor ()
  (let ((is-on-quote (or (= (char-after) ?\") (= (char-after) ?\')))
        (start-pos
         (pcase (char-before (point))
           (?\" (+ (point) 2)) ;; here im going to assume this is #
           (?' (+ (point) 2))
           (?# (1+ (point)))
           (_ (point)))))
    (if is-on-quote
        nil
      (let ((pos-start
             (condition-case nil
                 (scan-sexps start-pos -1)
               (scan-error
                -1)))
            (pos-end
             (condition-case nil
                 (scan-sexps start-pos 1)
               (scan-error
                -1))))
        (let ((str-len (- pos-end pos-start))
              (start-near-char (char-before pos-start))
              (end-near-char (char-after pos-end)))
          (if (and (= str-len 7)
                   start-near-char
                   end-near-char
                   (= start-near-char end-near-char)
                   (or (= start-near-char ?\")
                       (= start-near-char ?\')))
              (list
               (buffer-substring-no-properties pos-start pos-end)
               pos-start
               pos-end)
            nil))))))

(defun is-hex-code (str)
  (if str
      (string-match-p "^#[0-9a-fA-F]\\{6\\}$" str)
    nil))

(defun add-color-mark (str-color pos-start pos-end)
  (let ((ov (make-overlay pos-start pos-end)))
    (overlay-put ov 'color-mark-custom t)
    (overlay-put
     ov 'display
     (concat
      (propertize "▣" 'face `(:foreground ,str-color)) str-color))))

(defun clear-buffer-color-marks ()
  (remove-overlays (point-min) (point-max) 'color-mark-custom t))
