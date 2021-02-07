;;; init-lsp.el --- Provides completion engine -*- lexical-binding: t -*-
;;; Commentary:
;; Intellisense like binding with lsp-mode
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(defun efs/lsp-mode-setup ()
  "Show path to project."
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "s-8")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :diminish
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-peek-enable t
        lsp-ui-sideline-enable t
        lsp-ui-imenu-enable t
        lsp-ui-flycheck-enable t))

(use-package lsp-treemacs
  :diminish
  :after (lsp treemacs)
  :commands (lsp-treemacs-errors-list))

(use-package lsp-ivy
  :diminish
  :after (lsp ivy))

(use-package lsp-ui
  :diminish
  :commands (lsp-ui-mode))

(dolist (mode '(c++-mode-hook
                c-mode-hook
                css-mode-hook
                dockerfile-mode-hook
                less-css-mode-hook
                php-mode-hook
                sass-mode-hook
                scss-mode-hook
                typescript-mode-hook
                web-mode-hook))
  (add-hook mode #'lsp))

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)

  :after (python-mode)
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  (setq dap-python-debugger 'debugpy)
  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
   :keymaps 'lsp-mode-map
   :prefix lsp-keymap-prefix
   "d" '(dap-hydra t :wk "debugger")))

(provide 'init-lsp)
;;; init-lsp.el ends here
