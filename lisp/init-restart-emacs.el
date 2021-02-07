;;; init-restart-emacs.el --- loads restart-emacs package -*- lexical-binding: t -*-

;;; Commentary:
;; Provides only the command “restart-emacs”.

;;; Code:

(unless (package-installed-p 'restart-emacs)
  (package-install 'restart-emacs))

(provide 'init-restart-emacs)
;;; init-restart-emacs.el ends here
