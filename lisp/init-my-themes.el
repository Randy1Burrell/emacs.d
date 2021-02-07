;;; init-my-themes.el --- Support Yaml files -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;; When using helm & info & default, mode line looks prettier.
(use-package spaceline
  :custom (spaceline-buffer-encoding-abbrev-p nil)
  ;; Use an arrow to seperate modeline information
  (powerline-default-separator 'arrow)
  ;; Show “line-number : column-number” in modeline.
  (spaceline-line-column-p t)
  ;; Use two colours to indicate whether a buffer is modified or not.
  (spaceline-highlight-face-func 'spaceline-highlight-face-modified)
  :config (custom-set-faces '(spaceline-unmodified ((t (:foreground "black" :background "gold")))))
  (custom-set-faces '(spaceline-modified   ((t (:foreground "black" :background "cyan")))))
  (require 'spaceline-config)
  (spaceline-helm-mode)
  (spaceline-info-mode)
  (spaceline-emacs-theme))

(unless (package-installed-p 'beacon)
  (package-install 'beacon))
(setq beacon-color "#666600")

(provide 'init-my-themes)
;;; init-my-themes.el ends here
