;; some custom keywords
(require 'org)

(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "ONGOING(o)"
         "WAITING(w)"
         "MAYBE(m)"
         "|"
         "DONE(d)"
         "CANCELLED(c)")))

(defvar faded-green "#A9D344")
(defvar faded-yellow "#CEB581")
(defvar faded-blue "#64B5F6")
(defvar faded-gray "#9E9E9E")
(defvar faded-magenta "#C792EA")
(defvar faded-orange "#E8A87C")

(setq org-todo-keyword-faces
      `(("TODO" . (:foreground ,faded-yellow :weight bold))
        ("ONGOING" . (:foreground ,faded-magenta :weight bold))
        ("WAITING"
         .
         (:foreground ,faded-blue :weight bold :slant italic))
        ("MAYBE"
         .
         (:foreground ,faded-orange :weight normal :slant italic))
        ("DONE" . (:foreground ,faded-green :weight bold))
        ("CANCELLED"
         .
         (:foreground ,faded-gray :weight bold :strike-through t))))

(provide 'org-keywords)
