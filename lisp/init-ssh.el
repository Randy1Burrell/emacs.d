;;; init-ssh.el --- Provides omnisharp -*- lexical-binding: t -*-
;;; Commentary:
;; csharp intellisense like bindings
;;; Code:

(unless (package-installed-p 'ssh)
  (package-install 'ssh))

(require 'ssh)
(setq ssh-directory-tracking-mode 'ftp)
(add-hook 'ssh-mode-hook (lambda ()
                           (setq shell-dirtrack-mode t)
                           (setq shell-dirtrackp t)))

;; (defun connect-remote ()
;;   (interactive)
;;   (dired "/user@192.168.1.5:/"))

(defun connect-website ()
  (interactive)
  (ssh "WebsiteBlog"))

(defun connect-website-rb ()
  (interactive)
  (ssh "WebsiteBlogRB"))

(provide 'init-ssh)
;;; init-ssh.el ends here
