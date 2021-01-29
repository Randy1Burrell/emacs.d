;;; init-defaults.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;----------------------------------------------------------------------------
;; Setup some stuff for my frame
;;----------------------------------------------------------------------------
(unless (package-installed-p 'fancy-battery)
  (package-install 'fancy-battery))

(setq battery-update-interval 15)
(setq fancy-battery-show-percentage t)
(add-hook 'after-init-hook #'fancy-battery-mode)

(setq display-time-day-and-date t)
(display-time)

;;----------------------------------------------------------------------------
;; Frame title and dimension
;;----------------------------------------------------------------------------
(setq rb/new-frame-title (concat " " user-login-name " is the best (•̀ᴗ•́)"))
(setq frame-title-format '("%b --> " rb/new-frame-title))
(setq load-prefer-newer t)
(setq enable-local-variables :safe)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;----------------------------------------------------------------------------
;; Taking care of the cursor and lines
;;----------------------------------------------------------------------------
(blink-cursor-mode 0)
(global-hl-line-mode t)
;; (add-hook 'find-file-hook '(lambda () (set-default 'truncate-lines t)))
;; (set-default 'truncate-lines t)

(dolist (mode '(prog-mode-hook
                text-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (set-default 'truncate-lines t))))

;;----------------------------------------------------------------------------
;; Save bookmarks automagically
;;----------------------------------------------------------------------------
(setq bookmark-save-flag 1)

;;----------------------------------------------------------------------------
;; Copied from:
;; https://superuser.com/questions/77314/how-to-do-select-column-then-do-editing-in-gnu-emacs
;;----------------------------------------------------------------------------
(setq cua-enable-cua-keys nil)
(setq cua-highlight-region-shift-only t)
(setq cua-toggle-set-mark nil)

;;----------------------------------------------------------------------------
;; change all prompts to y or n
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)


(setq user-full-name    "Randy Burrell"
      user-mail-address "rb@randyburrell.info")
;;----------------------------------------------------------------------------
;; This sets confirm killing emacs
;;----------------------------------------------------------------------------
;; (setq confirm-kill-emacs 'yes-or-no-p)

;;----------------------------------------------------------------------------
;; Line width
;;----------------------------------------------------------------------------
(setq-default fill-column 80
              indent-tabs-mode nil)

;;----------------------------------------------------------------------------
;; Let's just set the default shell
;;----------------------------------------------------------------------------
(setq explicit-shell-file-name "/bin/zsh")

;;----------------------------------------------------------------------------
;; Delete trailing white-spaces
;;----------------------------------------------------------------------------
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;;----------------------------------------------------------------------------
;; Use esc to exit mini-buffer
;;----------------------------------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


(provide 'init-defaults)
;;; init-defaults.el ends here
