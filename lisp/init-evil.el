;;; init-evil.el --- Provides evil -*- lexical-binding: t -*-
;;; Commentary:
;; vim like bindings
;;; Code:

(setq evil-want-keybinding nil)

(use-package evil
  :diminish
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-insert-state-map (kbd "C-k") 'evil-previous-visual-line)
  (define-key evil-insert-state-map (kbd "C-j") 'evil-next-visual-line)
  (define-key evil-insert-state-map (kbd "C-e") 'evil-append-line)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-set-leader '(normal visual) "\\" )
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
      (interactive "P")
      (pcase (or (car prefix) 0)
        (0  (kill-this-buffer))
        (4  (other-window 1)
            (kill-this-buffer)
            (unless (one-window-p) (delete-window)))
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
  (use-package evil-nerd-commenter
    :diminish
    :bind ("s-\\" . evilnc-comment-or-uncomment-lines)))

(provide 'init-evil)
;;; init-evil.el ends here
