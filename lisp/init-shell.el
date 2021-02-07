;;; init-shell.el --- Provides shell  -*- lexical-binding: t -*-
;;; Commentary:
;; Provides zsh shell script completion
;;; Code:

(unless (package-installed-p 'company-shell)
  (package-install 'company-shell))

;; (add-to-list 'company-backends
;; '(company-shell company-shell-env company-fish-shell))

(use-package term
  :config
  (setq explicit-shell-file-name "zsh") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun rb/configure-eshell ()
  "Configure eshell."
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-a") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :diminish)

(use-package eshell
  :hook (eshell-first-time-mode . rb/configure-eshell)
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t))
  :init
  (eshell-git-prompt-use-theme 'powerline))

(defun rb/remote-buffers ()
  "Turn off company-mode in remote buffers."
  (when (and (fboundp 'company-mode)
             (file-remote-p default-directory))
    (company-mode -1)))

(dolist (mode '(dired-mode-hook
                eshell-mode-hook))
  (add-hook mode 'rb/remote-buffers))

(provide 'init-shell)
;;; init-shell.el ends here
