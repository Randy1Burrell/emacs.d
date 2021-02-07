;;; init-magit.el --- Support Yaml files -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(unless (package-installed-p 'use-package)
  (package-install 'git-timemachine))
;; --------------------------------------------------------------------------
;; See here for a short & useful tutorial:
;; https://alvinalexander.com/git/git-show-change-username-email-address
;; --------------------------------------------------------------------------
(when (equal ""
             (shell-command-to-string "git config user.name"))
  (shell-command "git config --global user.name \"Randy Burrell\"")
  (shell-command "git config --global user.email \"randy1burrell@yahoo.com\""))

(defmacro rb/pretty-magit (WORD &optional ICON PROPS NO-PROMPT?)
  "Replace sanitised WORD with ICON, PROPS and by default add to prompts.
Unless NO-PROMPT?"
  `(prog1
       (add-to-list 'pretty-magit-alist
                    (list (rx bow (group ,WORD (eval (if ,NO-PROMPT? "" ":"))))
                          ,ICON ',PROPS))
     (unless ,NO-PROMPT?
       (add-to-list 'pretty-magit-prompt (concat ,WORD ": ")))))

(defmacro rb/pretty-magit-no-semi (WORD &optional ICON PROPS NO-PROMPT?)
  "Replace sanitised WORD with ICON, PROPS and by default add to prompts.
Unless NO-PROMPT?"
  `(prog1
       (add-to-list 'pretty-magit-alist
                    (list (rx bow (group ,WORD (eval (if ,NO-PROMPT? "" ""))))
                          ,ICON ',PROPS))
     (unless ,NO-PROMPT?
       (add-to-list 'pretty-magit-prompt (concat ,WORD " ")))))
;; Set up who prompts on commit
(setq pretty-magit-alist nil)
(setq pretty-magit-prompt nil)
(rb/pretty-magit "feat" "🆕")
(rb/pretty-magit "docs" "📁")
(rb/pretty-magit "fix" "🔨")
(rb/pretty-magit "style" "🔭")
(rb/pretty-magit "refactor" "🐰")
(rb/pretty-magit-no-semi "[Feat]" "🆕")
(rb/pretty-magit-no-semi "[Docs]" "📁")
(rb/pretty-magit-no-semi "[Fix]" "🔨")
(rb/pretty-magit-no-semi "[Style]" "🔭")
(rb/pretty-magit-no-semi "[Refactor]" "🐰")

;; TODO: Figure out why I can't use certain key bindings in magit commit buffer
(defun add-magit-faces ()
  "Add face properties and compose symbols for buffer from pretty-magit."
  (interactive)
  (with-silent-modifications
    (--each pretty-magit-alist
      (-let (((rgx icon props) it))
        (save-excursion
          (goto-char (point-min))
          (while (search-forward-regexp rgx nil t)
            (compose-region
             (match-beginning 1) (match-end 1) icon)
            (when props
              (add-face-text-property
               (match-beginning 1) (match-end 1) props))))))))

(advice-add 'magit-status :after 'add-magit-faces)
(advice-add 'magit-refresh-buffer :after 'add-magit-faces)

(setq use-magit-commit-prompt-p nil)

(defun use-magit-commit-prompt (&rest args)
  (setq use-magit-commit-prompt-p t))

(defun magit-commit-prompt ()
  "Magit prompt and insert commit header with faces."
  (interactive)
  (when use-magit-commit-prompt-p
    (setq use-magit-commit-prompt-p nil)
    (insert (ivy-read "Commit Type " pretty-magit-prompt
                      :require-match t :sort t :preselect "fix"))
    (add-magit-faces)
    (evil-insert 1)))

(remove-hook 'git-commit-setup-hook 'with-editor-usage-message)
(add-hook 'git-commit-setup-hook 'magit-commit-prompt)
(advice-add 'magit-commit :after 'use-magit-commit-prompt)

;; MA: The todo keywords work in code too!
(use-package magit-todos
  :after magit
  :after hl-todo
  :hook (org-mode . magit-todos-mode)
  :config
  ;; For some reason cannot use :custom with this package.
  (custom-set-variables
   '(magit-todos-keywords (list "TODO" "FIXME" "MA" "WK" "JC")))
  ;; Ignore TODOs mentioned in exported HTML files; they're duplicated from org src.
  (setq magit-todos-exclude-globs '("*.html" "*.map"))
  (magit-todos-mode))

(defun my/git-commit-reminder ()
  (insert "\n\n# The commit subject line ought to finish the phrase:
# “If applied, this commit will ⟪your subject line here⟫.”")
  (beginning-of-buffer)
  (end-of-line))

(add-hook 'git-commit-setup-hook 'my/git-commit-reminder)

;; Trying to solve slow commits in lager reposittories
(remove-hook 'server-switch-hook 'magit-commit-diff)

(use-package forge)

(provide 'init-magit)
;;; init-magit.el ends here
