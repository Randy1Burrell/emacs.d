;;; init-perspective.el --- Provides omnisharp -*- lexical-binding: t -*-
;;; Commentary:
;; perspective intellisense like bindings
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package perspective
  :config
  (setq persp-state-default-file "~/.emacs.d/persp-confs/persp-auto-save")
  (persp-mode)
  :bind (("s-b" . persp-counsel-switch-buffer)
         ("s-M-b" . persp-ivy-switch-buffer)
         ("C-x b" . persp-switch-to-buffer*)
         ("C-x k" . persp-kill-buffer*)))

(add-hook 'kill-emacs-hook #'persp-state-save)

(provide 'init-perspective)
