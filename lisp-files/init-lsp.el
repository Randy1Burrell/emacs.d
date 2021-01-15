;;; init-lsp.el --- Provides completion engine -*- lexical-binding: t -*-
;;; Commentary:
;; Intellisense like binding with lsp-mode
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package lsp-mode
  :defer t
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

(setq lsp-keymap-prefix "s-8"
      lsp-ui-doc-enable t
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)

(provide 'init-lsp)
;;; init-lsp.el ends here
