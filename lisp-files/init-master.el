;;; init-master.el --- loads init-master.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;;--------------------------------------------------------------------------------
;; Wrap long lines when editing text
;;--------------------------------------------------------------------------------
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;;--------------------------------------------------------------------------------
;; Do not show the “Fill” indicator in the mode line.
;;--------------------------------------------------------------------------------
(diminish 'auto-fill-function)

;;--------------------------------------------------------------------------------
;; Bent arrows at the end and start of long lines.
;;--------------------------------------------------------------------------------
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(diminish 'visual-line-mode)
(global-visual-line-mode 0)

(use-package flyspell
  :diminish
  :hook ((prog-mode . flyspell-prog-mode)
         ((org-mode text-mode) . flyspell-mode)))

(setq ispell-program-name "/usr/local/bin/aspell")
(eval-after-load "flyspell"
  ' (progn
      (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
      (define-key flyspell-mouse-map [mouse-3] #'undefined))) ;; set the default dictionary

(global-font-lock-mode t)

(custom-set-faces '(flyspell-incorrect ((t (:inverse-video t)))))
(setq ispell-silently-savep t)

(setq ispell-dictionary "en_GB")

(setq ispell-personal-dictionary "~/.emacs.d/.aspell.en.pws")

(add-hook          'c-mode-hook 'flyspell-prog-mode)
(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)

;;--------------------------------------------------------------------------------
(use-package wordnut
  :bind ("M-!" . wordnut-lookup-current-word))

;;--------------------------------------------------------------------------------
;; Use M-& for async shell commands.
;; Fix spelling as you type ---thesaurus & dictionary too!:11 ends here
;;--------------------------------------------------------------------------------
(use-package speed-type :defer t)

(use-package google-translate
  :defer t
  :config
  (global-set-key "\C-ct" 'google-translate-at-point))

;;--------------------------------------------------------------------------------
;; Function used to clone repositories use Git
;;--------------------------------------------------------------------------------
(cl-defun maybe-clone (remote &optional (local (concat "~/" (file-name-base remote))))
  "Clone a REMOTE repository if the LOCAL directory does not exist.

Yields ‘repo-already-exists’ when no cloning transpires,
otherwise yields ‘cloned-repo’.

LOCAL is optional and defaults to the base name; e.g.,
if REMOTE is https://github.com/X/Y then LOCAL becomes ~/Y."
  (if (file-directory-p local)
      'repo-already-exists
    (async-shell-command (concat "git clone " remote " " local))
    (add-to-list 'magit-repository-directories `(,local   . 0))
    'cloned-repo))

;;--------------------------------------------------------------------------------
;; Gulp packages from GitHub
;;--------------------------------------------------------------------------------
(maybe-clone "git@github.com:Randy1Burrell/emacs-gulpjs.git"
             "~/.emacs.d/site-lisp/gulp")

(when (file-directory-p "~/.emacs.d/site-lisp/gulp")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/gulp")
  (require'gulpjs))

(maybe-clone "git@github.com:NicolasPetton/gulp-task-runner.git"
             "~/.emacs.d/site-lisp/gulp-task-runner")

(when (file-directory-p "~/.emacs.d/site-lisp/gulp-task-runner")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/gulp-task-runner")
  (require 'gulp-task-runner))

;;--------------------------------------------------------------------------------
;; Pull down and use languagetool
;;--------------------------------------------------------------------------------
(when (not (file-directory-p "~/.emacs.d/LanguageTool"))
  (shell-command-to-string
   "curl -LO https://languagetool.org/download/LanguageTool-5.1.zip")
  (unless (file-directory-p "~/.emacs.d/LanguageTool")
    (shell-command-to-string
     "unzip Languagetool-5.1.zip
      mv LanguageTool-5.1 ~/.emacs.d/LanguageTool &&
      rm LanguageTool-5.1.zip")))

(unless (not (file-directory-p "~/.emacs.d/LanguageTool"))
  (use-package langtool
    :custom
    (langtool-language-tool-jar
     "~/.emacs.d/LanguageTool/languagetool-commandline.jar")))

;;--------------------------------------------------------------------------------
;; Quickly check, correct, then clean up /region/ with M-^
;;--------------------------------------------------------------------------------
(eval-after-load 'langtool
  (progn
    (add-hook 'langtool-error-exists-hook
              (lambda ()
                (langtool-correct-buffer)
                (langtool-check-done)))

    (global-set-key "\M-^"
                    (lambda ()
                      (interactive)
                      (message "Grammar checking begun ...")
                      (langtool-check)))))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(use-package editorconfig)

(unless (package-installed-p 'editorconfig-generate)
  (package-install 'editorconfig-generate))

(use-package hl-todo
  :config
  (mapc (lambda (x)
          (add-to-list 'hl-todo-keyword-faces (cons x "#dc8cc3")))
        '("TEST" "MA" "WK" "JC" "NOTE"))
  (global-hl-todo-mode))

(defun add-watchwords () "Add TODO: words to font-lock keywords."
       (font-lock-add-keywords nil
                               '(("\\(\\<TODO\\|\\<FIXME\\|\\<HACK\\|\\<NOTE\\|@.+\\):" 1
                                  font-lock-warning-face t))))

(add-hook 'prog-mode-hook #'add-watchwords)


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(global-set-key "\M-k" '(lambda () (interactive) (kill-line 0)) )

(global-set-key (kbd "C-x k")
                (lambda (&optional prefix)
                  "C-x k     ⇒ Kill current buffer & window
C-u C-x k ⇒ Kill OTHER window and its buffer
C-u C-u C-x C-k ⇒ Kill all other buffers and windows

Prompt only if there are unsaved changes."
                  (interactive "P")
                  (pcase (or (car prefix) 0)
                    (0  (kill-this-buffer))
                    (4  (other-window 1)
                        (kill-this-buffer)
                        (unless (one-window-p) (delete-window)))
                    (16   (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
                          (delete-other-windows)))))

(unless (package-installed-p 'vimrc-mode)
  (package-install 'vimrc-mode))

(unless (package-installed-p 'zlc)
  (package-install 'zlc))

(unless (package-installed-p 'eshell-git-prompt)
  (package-install 'eshell-git-prompt))

(eshell-git-prompt-use-theme 'powerline)

(provide 'init-master)
;;; init-master.el ends here
