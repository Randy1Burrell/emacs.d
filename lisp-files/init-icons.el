;;; init-icons.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Only do this once:
(when nil
  (use-package all-the-icons
    :ensure t)
  (all-the-icons-install-fonts 'install-without-asking))

;; :-)
;; Make mail look pretty
(use-package all-the-icons-gnus
  :defer t
  :config (all-the-icons-gnus-setup))

;; While we're at it: Make dired, ‘dir’ectory ‘ed’itor, look pretty
(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(provide 'init-icons)
;;; init-icons.el ends here
