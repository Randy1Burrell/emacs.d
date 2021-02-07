;;; init-navigation.el --- Support navigation commands -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package windmove
  :config
  (windmove-default-keybindings 'super)
  (setq windmove-wrap-around t))

;;----------------------------------------------------------------------------
;; Use super h,j,k,l for window navigation comparing to vim move keys
;;----------------------------------------------------------------------------
(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-[") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "M-]") 'windmove-right)
(global-set-key (kbd "s-k") 'windmove-up)
(global-set-key (kbd "s-j") 'windmove-down)
(global-set-key (kbd "s-]") 'other-window)

(use-package buffer-flip
  :config
  (setq buffer-flip-skip-patterns
        '("^\\*"
          "^magi"
          "COMMIT_EDIT MSG"
          ;; "^\\*Messages\\*\\b"
          )))

;;----------------------------------------------------------------------------
;; key to begin cycling buffers.
;;----------------------------------------------------------------------------
(global-set-key (kbd "M-S-<tab>") 'buffer-flip-forward)
(global-set-key (kbd "M-<tab>") 'buffer-flip-backward)

;;----------------------------------------------------------------------------
;; Let's get some keys to do splits both vertically and horizontally.
;; Let's also delete window with a more easier key
;;----------------------------------------------------------------------------
(global-set-key (kbd "s-.") 'split-window-horizontally)
(global-set-key (kbd "s-/") 'split-window-vertically)
(global-set-key (kbd "s-;") 'delete-window)


;;----------------------------------------------------------------------------
;; Buffer manipulation
;;----------------------------------------------------------------------------
(global-set-key (kbd "s-b") 'counsel-switch-buffer)
(global-set-key (kbd "s-M-b") 'ivy-switch-buffer)

;;----------------------------------------------------------------------------
;; Kill this buffer.
;;----------------------------------------------------------------------------
(global-set-key (kbd "s-1")
                (lambda ()
                  (interactive)
                  (kill-this-buffer)))

;;----------------------------------------------------------------------------
;; Kill buffer and close the current window.
;;----------------------------------------------------------------------------
(global-set-key (kbd "s-r")
                (lambda ()
                  (interactive)
                  (kill-this-buffer)
                  (delete-window)))

;;----------------------------------------------------------------------------
;; Great package for switching between windows
;;----------------------------------------------------------------------------
(unless (package-installed-p 'ace-window)
  (package-install 'ace-window))

(global-set-key (kbd "M-{") 'ace-window)

(provide 'init-navigation)
;;; init-navigation.el ends here
