;;; init-helpful.el --- Provides helpful -*- lexical-binding: t -*-
;;; Commentary:
;; helpful - a better way to view help messages
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(provide 'init-helpful)
;;; init-helpful.el ends here
