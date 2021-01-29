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
(provide 'init-ssh)
;;; init-ssh.el ends here
