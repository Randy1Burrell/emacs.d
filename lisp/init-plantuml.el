;;; init-plantuml.el --- Provides plantuml-mode -*- lexical-binding: t -*-
;;; Commentary:
;; plantuml like bindings
;;; Code:

(unless (package-installed-p 'plantuml-mode)
  (package-install 'plantuml-mode))

(setq plantuml-path "~/.emacs.d/plantuml.jar")

(when (file-exists-p plantuml-path)
  (setq plantuml-jar-path plantuml-path)
  (setq plantuml-default-exec-mode 'jar))

;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(add-to-list
 'org-src-lang-modes '("plantuml" . plantuml))

(setq plantuml_helper_path "~/.emacs.d/site-lisp/plantuml_helpers.el")

(setq plantuml-dw-cmd
      (concat
       "curl "
       " -LO "
       "https://gist.githubusercontent.com/"
       "Randy1Burrell/7ed8899da46f2c73564a6103e419aa32/"
       "raw/d1bf8c898af7ea1a0f294087059dc76a6521f4d2/plantuml_helpers.el"))

(when (not (file-exists-p plantuml_helper_path))
  (shell-command-to-string plantuml-dw-cmd)
  (unless (file-exists-p plantuml_helper_path)
    (shell-command-to-string
     "mv plantuml_helpers.el ~/.emacs.d/site-lisp/"))
  (when (file-exists-p plantuml_helper_path)
    (add-to-list 'load-path plantuml_helper_path)
    (require 'plantuml_helpers)))

(provide 'init-plantuml)
;;; init-plantuml.el ends here
