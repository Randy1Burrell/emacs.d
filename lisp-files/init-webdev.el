;;; init-webbed.el --- loads treemacs package -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;;--------------------------------------------------------------------------------
;; Set up web-mode
;;--------------------------------------------------------------------------------
(unless (package-installed-p 'web-mode)
  (package-install 'web-mode))

;;--------------------------------------------------------------------------------
;; Setup tide server
;;--------------------------------------------------------------------------------
(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;;--------------------------------------------------------------------------------
;; aligns annotation to the right hand side
;;--------------------------------------------------------------------------------
(setq company-tooltip-align-annotations t)

;;--------------------------------------------------------------------------------
;; formats the buffer before saving
;;--------------------------------------------------------------------------------
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(unless (package-installed-p 'prettier-js)
  (package-install 'prettier-js))

(when (maybe-require-package 'flycheck))

;;--------------------------------------------------------------------------------
;; Run web-mode on tsx files
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;;--------------------------------------------------------------------------------
;; Run web-mode on jsx files
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;;--------------------------------------------------------------------------------
;; Run web-mode on ts files
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "ts" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;;--------------------------------------------------------------------------------
;; Run web-mode on js files
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "js" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;;--------------------------------------------------------------------------------
;; Run web-mode for these files too
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))

;;--------------------------------------------------------------------------------
;; Try using both web-mode and php-mode at the same time
;;--------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))

;;--------------------------------------------------------------------------------
;; configure jsx-tide checker to run after your default jsx checker
;;--------------------------------------------------------------------------------
;; (flycheck-add-mode 'javascript-eslint 'web-mode)

(defun setup-tide-mode ()
  "Setup function for tide."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'js-mode-hook 'setup-tide-mode)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'php-mode-hook 'web-mode)
(add-hook 'js-mode-hook 'prettier-js-mode)

(setq prettier-js-args '(
                         "--bracket-spacing" "true"
                         "--jsx-bracket-same-line" "false"
                         "--jsx-single-quote" "true"
                         "--print-width" "80"
                         "--single-quote" "true"
                         "--tab-width" "4"
                         "--trailing-comma" "all"
                         "--use-tabs" "false"
                         ))

(unless (package-installed-p 'emmet-mode)
  (package-install 'emmet-mode))

(add-hook 'web-mode-hook  'emmet-mode)

(add-hook 'web-mode-before-auto-complete-hooks
          '(lambda ()
             (let ((web-mode-cur-language
                    (web-mode-language-at-pos)))
               (if (string= web-mode-cur-language "php")
                   (yas-activate-extra-mode 'php-mode)
                 (yas-deactivate-extra-mode 'php-mode))
               (if (string= web-mode-cur-language "css")
                   (setq emmet-use-css-transform t)
                 (setq emmet-use-css-transform nil)))))

(provide 'init-webdev)
;;; init-webdev.el ends here
