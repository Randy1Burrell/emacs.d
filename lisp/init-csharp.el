;;; init-csharp.el --- Provides omnisharp -*- lexical-binding: t -*-
;;; Commentary:
;; csharp intellisense like bindings
;;; Code:

(unless (package-installed-p 'omnisharp)
  (package-install 'omnisharp))

(provide 'init-csharp)
;;; init-csharp.el ends here
