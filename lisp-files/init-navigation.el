;;; init-navigation.el --- Support navigation commands -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile (require 'cl))

(use-package windmove
  :config
  (windmove-default-keybindings 'super)
  (setq windmove-wrap-around t))

(defun ignore-error-wrapper (fn)
  "Funtion return new function that ignore errors.
   The function wraps a function with `ignore-errors' macro."
  (lexical-let ((fn fn))
    (lambda ()
      (interactive)
      (ignore-errors
        (funcall fn)))))

;; Use super h,j,k,l for window navigation comparing to vim move keys
(global-set-key (kbd "s-h") (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "M-[") (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "s-[") (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "s-l") (ignore-error-wrapper 'windmove-right))
(global-set-key (kbd "M-]") (ignore-error-wrapper 'windmove-right))
(global-set-key (kbd "s-k") (ignore-error-wrapper 'windmove-up))
(global-set-key (kbd "s-j") (ignore-error-wrapper 'windmove-down))
(global-set-key (kbd "s-]") 'other-window)

(use-package buffer-flip
  :ensure t
  :config
  (setq buffer-flip-skip-patterns
        '("^\\*"
          "^magit"
          "^\\*helm\\b"
          "^\\*Help\\*\\b"
          "COMMIT_EDITMSG"
          "^\\*Ibuffer\\*\\b"
          "^\\*Messages\\*\\b")))

;; key to begin cycling buffers.
(global-set-key (kbd "M-S-<tab>") 'buffer-flip-forward)
(global-set-key (kbd "M-<tab>") 'buffer-flip-backward)

(unless (package-installed-p 'ace-window)
  (package-install 'ace-window))

(global-set-key (kbd "M-{") 'ace-window)

(provide 'init-navigation)
;;; init-navigation.el ends here
