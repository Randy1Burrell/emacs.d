;;; init-shell.el --- Provides shell  -*- lexical-binding: t -*-
;;; Commentary:
;; Provides zsh shell script completion
;;; Code:

(unless (package-installed-p 'company-shell)
  (package-install 'company-shell))

(add-to-list 'company-backends
             '(company-shell company-shell-env company-fish-shell))

(provide 'init-shell)
;;; init-shell.el ends here
