;;; init-use-package.el --- Provides omnisharp -*- lexical-binding: t -*-
;;; Commentary:
;; Package manager like brew for MacOSX
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(provide 'init-use-package)
;;; init-use-package.el ends here
