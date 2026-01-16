(require 'org)

(if (not (file-exists-p "~/org-agenda.org"))
    (with-temp-file "~/org-agenda.org"
      (insert "#+TITLE: Agenda\n\n* Tasks\n")))
(setq org-agenda-files '("~/org-agenda.org"))
(global-set-key
 (kbd "C-c A")
 (lambda ()
   (interactive)
   (find-file "~/org-agenda.org")))
;; todo template
(setq org-capture-templates
      '(("t"
         "Todo"
         entry
         (file+headline "~/org-agenda.org" "Tasks")
         "** TODO %?\n  SCHEDULED: %t\n")))
;; TODO: add more template and helper functions
(provide 'custom-org-agenda)
