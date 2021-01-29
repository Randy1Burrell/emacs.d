;;; init-evil.el --- Provides evil -*- lexical-binding: t -*-
;;; Commentary:
;; vim like bindings
;;; Code:

(setq evil-want-keybinding nil)

(use-package evil
  :diminish
  :bind ("<C-tab>" . 'evil-mode)
  :config
  (evil-set-leader '(normal visual) "\\" )
  (evil-define-key '(insert) 'global (kbd "C-'") 'evil-normal-state)
  (evil-define-key '(normal visual) 'global (kbd "<leader>s") 'save-buffer)
  (evil-define-key '(normal visual) 'global (kbd "<leader>`") 'split-window-right)
  (evil-define-key '(normal visual) 'global (kbd "<leader>;") 'split-window-below)
  (evil-define-key '(normal visual) 'global (kbd "<leader>x") 'kill-buffer-and-window)
  (evil-define-key '(normal visual) 'global (kbd "<leader>h") 'evil-window-increase-height)
  (evil-define-key '(normal visual) 'global (kbd "<leader>w") 'evil-window-increase-width)
  (evil-define-key '(normal visual) 'global (kbd "<leader>=") 'evil-window-decrease-height)
  (evil-define-key '(normal visual) 'global (kbd "<leader>-") 'evil-window-decrease-width)
  (evil-define-key '(normal visual) 'global (kbd "<leader>ew") 'balance-windows)
  (evil-define-key '(normal visual) 'global (kbd "<leader>b") 'switch-to-buffer)
  (evil-define-key '(normal visual) 'global (kbd "<leader>[") 'other-frame)
  (evil-define-key '(normal visual) 'global (kbd "<leader>f") 'make-frame)
  (evil-define-key '(normal visual) 'global (kbd "<leader>0") 'delete-frame)
  (evil-define-key '(normal visual) 'global (kbd "<leader>q")
    (lambda (&optional prefix)
      "C-x k     ⇒ Kill current buffer & window
C-u C-x k ⇒ Kill OTHER window and its buffer
C-u C-u C-x C-k ⇒ Kill all other buffers and windows

Prompt only if there are unsaved changes."
      (interactive "P")
      (pcase (or (car prefix) 0)
        ;; C-x k     ⇒ Kill current buffer & window
        (0  (kill-this-buffer))
        ;; (unless (one-window-p) (delete-window)))
        ;; C-u C-x k ⇒ Kill OTHER window and its buffer
        (4  (other-window 1)
            (kill-this-buffer)
            (unless (one-window-p) (delete-window)))
        ;; C-u C-u C-x C-k ⇒ Kill all other buffers and windows
        (16   (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
              (delete-other-windows)))))
  (use-package evil-surround
    :diminish
    :after evil
    :config
    (global-evil-surround-mode 1))
  (use-package evil-collection
    :diminish
    :after evil
    :config
    (evil-collection-init))
  )


(provide 'init-evil)
;;; init-evil.el ends here
