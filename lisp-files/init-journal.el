;;; init-journal.el --- journaling -*- lexical-binding: t -*-
;;; Commentary: I use this as my tool for journaling.
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-packae))

(defun rb/org-journal-new-entry (prefix)
  "Open today’s journal file and start a new entry.
  With a prefix, we use the work journal; otherwise the personal journal."
  (interactive "P")
  (-let [org-journal-file-format
         (if prefix
             (if (or (= prefix 1) (= prefix 2))
                 "Planner-%y-%m-%d.org"
               "Work-%Y-%m-%d.org")
           "Personal-%Y-%m-%d.org")]
    (org-journal-new-entry nil)
    (org-mode)
    (org-show-all))
  (when (= prefix 1)
    (split-window-horizontally)
    (other-window 1)
    (org-agenda nil "g")
    ;; (make-frame-command)
    (split-window-vertically)
    (other-window 1)
    (org-agenda nil "p")
    (other-window 1)))
;;------------------------------------------------------------------------------
;; C-u C-c j ⇒ Work journal ;; C-c C-j ⇒ Personal journal ;; C-u 1 C-c j Planner
;;------------------------------------------------------------------------------
(use-package org-journal
  :ensure t
  :bind (("C-c j" . rb/org-journal-new-entry))
  :config
  (setq org-journal-dir         "~/Dropbox/journal/"
        org-journal-file-type   'yearly
        org-journal-file-format "Personal-%Y-%m-%d.org"))

(setq org-journal-enable-agenda-integration t
      org-icalendar-store-UID t
      org-icalendar-include-todo "all"
      org-icalendar-combined-agenda-file "~/Dropbox/journal/org-journal.ics")

;; The Setup:1 ends here
(provide 'init-journal)
;;; init-journal.el ends here
