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
;; configure jsx-tide checker to run after your default jsx checker
;;--------------------------------------------------------------------------------
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

;;--------------------------------------------------------------------------------
;; Run prettier and tide-mode on these file types
;;--------------------------------------------------------------------------------
(defun rb/prettier ()
  "If certain file extension match then set up tide mode and prettier."
  (mapc
   (lambda (x)
     (add-hook 'web-mode-hook
               (lambda ()
                 (when (string-equal x (file-name-extension buffer-file-name))
                   (setup-tide-mode)
                   (prettier-js-mode)))))
   '("scss" "sass" "html" "htm" "css" "js" "ts" "jsx" "tsx")))

(rb/prettier)
;;--------------------------------------------------------------------------------
;; Add these files to web-mode list
;;--------------------------------------------------------------------------------

(defun rb/web-mode ()
  "Add some file to `auto-mode-alist'."
  (mapc
   (lambda (x)
     (add-to-list 'auto-mode-alist (cons x 'web-mode)))
   '("\\.css\\'" "\\.htm\\'" "\\.html\\'" "\\.js\\'"
     "\\.jsx\\'" "\\.php\\'" "\\.sass\\'" "\\.scss\\'"
     "\\.ts\\'" "\\.tsx\\'")))

(rb/web-mode)
;;--------------------------------------------------------------------------------
;; Just in-case I missed these files run prettier in these modes
;;--------------------------------------------------------------------------------
(add-hook 'js-mode-hook 'setup-tide-mode)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'js-mode-hook 'prettier-js-mode)

;;--------------------------------------------------------------------------------
;; Let's also set up prettier's defaults
;;--------------------------------------------------------------------------------
(setq prettier-js-args
      '(
        "--bracket-spacing" "true"
        "--jsx-bracket-same-line" "false"
        "--jsx-single-quote" "true"
        "--print-width" "80"
        "--single-quote" "true"
        "--tab-width" "4"
        "--trailing-comma" "all"
        "--use-tabs" "false"
        ))

;;--------------------------------------------------------------------------------
;; Run emmet-mode in web-mode
;;--------------------------------------------------------------------------------
(unless (package-installed-p 'emmet-mode)
  (package-install 'emmet-mode))

(add-hook 'web-mode-hook  'emmet-mode)

;;--------------------------------------------------------------------------------
;; An auto complete hook for CSS and PHP
;;--------------------------------------------------------------------------------
(add-hook
 'web-mode-before-auto-complete-hooks
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
