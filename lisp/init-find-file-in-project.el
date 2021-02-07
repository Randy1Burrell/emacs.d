;;; init-find-file-in-project.el --- loads treemacs package -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(unless (package-installed-p 'use-package)
    (package-install 'use-package))

(use-package find-file-in-project
    :config
    (remove-hook 'file-name-at-point-functions 'ffap-guess-file-name-at-point))
;;; init-find-file-in-project.el ends here
