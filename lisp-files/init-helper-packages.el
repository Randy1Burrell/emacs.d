;;; init-helper-packages.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package undo-tree
  :ensure t
  :diminish ;; Don't show an icon in the modeline
  :config
  ;; Always have it on
  (global-undo-tree-mode)

  ;; Each node in the undo tree should have a timestamp.
  (setq undo-tree-visualizer-timestamps t)

  ;; Show a diff window displaying changes between undo nodes.
  (setq undo-tree-visualizer-diff t))

(use-package company-emoji
  :ensure t
  :config (add-to-list 'company-backends 'company-emoji))

(use-package emojify
  :ensure t
  :config (setq emojify-display-style 'image)
  :init (global-emojify-mode 1)) ;; This will install missing images if needed.

(use-package synosaurus
  :ensure t
  :diminish synosaurus-mode
  :init    (synosaurus-mode)
  :config  (setq synosaurus-choose-method 'popup) ;; 'ido is default.
  (global-set-key (kbd "M-#") 'synosaurus-choose-and-replace))

(use-package s
  :ensure t)

(use-package f
  :ensure t)

(use-package haskell-mode
  :ensure t)

(use-package dash
  :ensure t)

(use-package toc-org
  :ensure t
  ;; Automatically update toc when saving an Org file.
  :hook (org-mode . toc-org-mode)
  ;; Use both “:ignore_N:” and ":export_N:” to exlude headings from the TOC.
  :custom (toc-org-noexport-regexp
           "\\(^*+\\)\s+.*:\\(ignore\\|noexport\\)\\([@_][0-9]\\)?:\\($\\|[^ ]*?:$\\)"))

(use-package persp-mode
  :ensure t)

(use-package persp-mode-projectile-bridge
  :ensure t)

(with-eval-after-load "persp-mode-autoloads"
  (setq wg-morph-on nil) ;; switch off animation
  (setq persp-autokill-buffer-on-remove 'kill-weak)
  (add-hook 'window-setup-hook #'(lambda () (persp-mode 1))))

(with-eval-after-load "persp-mode"
  (with-eval-after-load "ivy"
    (add-hook 'ivy-ignore-buffers
              #'(lambda (b)
                  (when persp-mode
                    (let ((persp (get-current-persp)))
                      (if persp
                          (not (persp-contain-buffer-p b persp))
                        nil)))))

    (setq ivy-sort-functions-alist
          (append ivy-sort-functions-alist
                  '((persp-kill-buffer   . nil)
                    (persp-remove-buffer . nil)
                    (persp-add-buffer    . nil)
                    (persp-switch        . nil)
                    (persp-window-switch . nil)
                    (persp-frame-switch  . nil))))))

(use-package origami
  ;; In Lisp languages, by default only function definitions are folded.
  :ensure t
  :hook ((agda2-mode lisp-mode c-mode) . origami-mode)
  :config
  (push '(agda2-mode . (origami-markers-parser "{-" "-}"))
        origami-parser-alist))

(use-package writegood-mode
  :ensure t
  ;; Load this whenver I'm composing prose.
  :hook (text-mode org-mode)
  ;; Don't show me the “Wg” marker in the mode line
  :diminish
  ;; Some additional weasel words.
  :config
  (--map (push it writegood-weasel-words)
         '("some" "simple" "simply" "easy" "often" "easily" "probably"
           "clearly"               ;; Is the premise undeniably true?
           "experience shows"      ;; Whose? What kind? How does it do so?
           "may have"              ;; It may also have not!
           "it turns out that")))  ;; How does it turn out so?
;; ↯ What is the evidence of highighted phrase? ↯

(use-package smartscan
  :ensure t
  :defer t
  :config
  (global-set-key (kbd "M-n") 'smartscan-symbol-go-forward)
  (global-set-key (kbd "M-p") 'smartscan-symbol-go-backward)
  (global-set-key (kbd "M-'") 'rb/symbol-replace))

(defun rb/symbol-replace (replacement)
  "Replace all standalone symbols in the buffer matching the one at point."
  (interactive  (list (read-from-minibuffer "Replacement for thing at point: " nil)))
  (save-excursion
    (let ((symbol (or (thing-at-point 'symbol) (error "No symbol at point!"))))
      (beginning-of-buffer)
      ;; (query-replace-regexp symbol replacement)
      (replace-regexp (format "\\b%s\\b" (regexp-quote symbol)) replacement))))

(use-package goto-chg
  :defer t
  :custom (glc-default-span 0))

(cl-defun rb/company-backend-with-yankpad (backend)
  "There can only be one main completion BACKEND.
Let's enable yasnippet/yankpad as a secondary for all
completion backends.
Src: https://emacs.stackexchange.com/a/10520/10352"

  (if (and (listp backend) (member 'company-yankpad backend))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yankpad))))

;; Yet another snippet extension program
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1) ;; Always have this on for when using yasnippet syntax within yankpad
  ;; respect the spacing in my snippet declarations
  (setq yas-indent-line 'fixed))

;; Alternative, Org-based extension program
(use-package yankpad
  :ensure t
  :defer 10
  :diminish
  :init
  ;; Location of templates
  (setq yankpad-file "~/.emacs.d/yankpad.org")
  ;; Ignore major mode, always use defaults.
  ;; Yankpad will freeze if no org heading has the name of the given category.
  (setq yankpad-category "Default")
  ;; Set company-backend as a secondary completion backend to all existing backends.
  ;; https://emacs.stackexchange.com/questions/10431/get-company-to-show-suggestions-for-yasnippet-names/10520#10520
  (setq company-backends (mapcar #'rb/company-backend-with-yankpad company-backends))
  :config
  (bind-key "<f9>" 'yankpad-map)
  (bind-key "<f12>" 'yankpad-expand)
  ;; If you want to complete snippets using company-mode
  ;; (add-to-list 'company-backends #'company-yankpad)
  ;; If you want to expand snippets with hippie-expand
  (add-to-list 'hippie-expand-try-functions-list #'yankpad-expand))

(cl-defun org-insert-link ()
  "Make an org link by inserting the URL copied to clipboard;
and prompting for the link description only.

  Type over the shown link to change it, or tab to move to the
  description field.

  This overrides Org-mode's built-in ‘org-insert-link’ utility;
  whence C-c C-l uses the snippet."
  (interactive)
  (insert "rb_org_insert_link")
  (yankpad-expand))

(provide 'init-helper-packages)
;;; init-helper-packages.el ends here
