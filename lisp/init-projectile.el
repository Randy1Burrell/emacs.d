;;; init-projectile.el --- Use Projectile for navigation within projects -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'projectile)
  (add-hook 'after-init-hook 'projectile-mode)

  ;; Shorter modeline
  (setq-default projectile-mode-line-prefix " Proj")

  (when (executable-find "rg")
    (setq-default projectile-generic-command "rg --files --hidden"))

  (with-eval-after-load 'projectile
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

  (when (maybe-require-package 'diminish)
    (diminish 'projectile-mode))

  (defadvice projectile-project-root (around ignore-remote first activate)
    "Turn off projectile in remote buffer."
    (unless (file-remote-p default-directory 'no-identification) ad-do-it))

  (maybe-require-package 'ibuffer-projectile))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package counsel-projectile
  :init (counsel-projectile-mode))

(provide 'init-projectile)
;;; init-projectile.el ends here
