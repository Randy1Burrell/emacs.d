;;; init-phpcbf.el --- loads phpcbf package -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'phpcbf)
  (package-install 'phpcbf))

(custom-set-variables
 '(phpcbf-executable "~/.composer/vendor/bin/phpcbf")
 '(phpcbf-standard "PSR2"))

(add-hook 'php-mode-hook 'phpcbf-enable-on-save)

(provide 'init-phpcbf)
;;; init-phpcbf.el ends here
