;;; init-golang.el --- Support Golang files -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package go-mode
  :defer t
  :config
  (setq compile-command "echo Building... && go build -v && echo Testing... && go test -v && echo Linter... && golint")
  (setq compilation-read-command nil))

(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "M-,") 'compile)
            (local-set-key (kbd "M-.") 'godef-jump)))
;; Set compile-command back to its original value
;; (setq compile-command (eval (car (get 'compile-command 'standard-value))))

(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))
(require 'lsp)
(add-hook 'go-mode-hook #'lsp-diferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  "Install and save lsp-go hooks."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(unless (package-installed-p 'go-eldoc)
  (package-install 'go-eldoc))

(add-hook 'go-mode-hook 'go-eldoc-setup)

(set-face-attribute 'eldoc-highlight-function-argument nil
                    :underline t :foreground "green"
                    :weight 'bold)


(add-hook 'go-mode-hook 'lsp-deferred)

(defun my-compilation-hook ()
  "Run at compilation time."
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h compilation-window-height)))))))

(add-hook 'compilation-mode-hook 'my-compilation-hook)

(global-set-key (kbd "C-x C-'") 'comment-or-uncomment-region)

(setq compilation-scroll-output t
      compilation-window-height 14)

(provide 'init-golang)
;;; init-golang.el ends here
