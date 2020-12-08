;;; init-defaults.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;--------------------------------------------------------------------------------
;; Setup some stuff for my frame
;;--------------------------------------------------------------------------------
(unless (package-installed-p 'fancy-battery)
  (package-install 'fancy-battery))

(setq battery-update-interval 15)
(setq fancy-battery-show-percentage t)
(add-hook 'after-init-hook #'fancy-battery-mode)

(setq display-time-day-and-date t)
(display-time)

;;--------------------------------------------------------------------------------
;; Set up line number
;;--------------------------------------------------------------------------------
(setq display-line-numbers-width-start t)
(global-display-line-numbers-mode      t)
(setq display-line-numbers-type 'relative)
(column-number-mode t)

;;--------------------------------------------------------------------------------
;; Frame title and dimension
;;--------------------------------------------------------------------------------
(setq frame-title-format '("%b " " Bugarel is #1 (•̀ᴗ•́)"))
(setq load-prefer-newer t)
(setq enable-local-variables :safe)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;--------------------------------------------------------------------------------
;; Taking care of the cursor and lines
;;--------------------------------------------------------------------------------
(blink-cursor-mode 0)
(global-hl-line-mode t)
(add-hook 'find-file-hook '(lambda () (set-default 'truncate-lines t)))
(set-default 'truncate-lines t)

;;--------------------------------------------------------------------------------
;; Save bookmarks automagically
;;--------------------------------------------------------------------------------
(setq bookmark-save-flag 1)

;;-------------------------------------------------------------------------------------------
;; Copied from:
;; https://superuser.com/questions/77314/how-to-do-select-column-then-do-editing-in-gnu-emacs
;;-------------------------------------------------------------------------------------------
(setq cua-enable-cua-keys nil)
(setq cua-highlight-region-shift-only t)
(setq cua-toggle-set-mark nil)

;;--------------------------------------------------------------------------------
;; change all prompts to y or n
;;--------------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)


(setq user-full-name    "Randy Burrell"
      user-mail-address "rb@randyburrell.info")
;;--------------------------------------------------------------------------------
;; This sets confirm killing emacs
;;--------------------------------------------------------------------------------
;; (setq confirm-kill-emacs 'yes-or-no-p)

;;--------------------------------------------------------------------------------
;; Line width
;;--------------------------------------------------------------------------------
(setq-default fill-column 80
              indent-tabs-mode nil)

(provide 'init-defaults)
;;; init-defaults.el ends here
