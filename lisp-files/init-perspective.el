;;; init-perspective.el --- Provides omnisharp -*- lexical-binding: t -*-
;;; Commentary:
;; perspective intellisense like bindings
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package perspective
  :config
  (persp-mode)
  :bind (("s-b" . persp-counsel-switch-buffer)
         ("s-M-b" . persp-ivy-switch-buffer)
         ("C-x b" . persp-switch-to-buffer*)
         ("C-x k" . persp-kill-buffer*)))

(use-package persp-mode-projectile-bridge
  :init
  (persp-mode-projectile-bridge-mode 1)
  :config
  (if persp-mode-projectile-bridge-mode
      (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
    (persp-mode-projectile-bridge-kill-perspectives)))

(global-set-key (kbd "C-x C-b") (lambda (arg)
                                  (interactive "P")
                                  (if (fboundp 'persp-bs-show)
                                      (persp-bs-show arg)
                                    (bs-show "all"))))

(provide 'init-perspective)
