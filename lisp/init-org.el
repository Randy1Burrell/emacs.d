;;; init-org.el --- Org-mode config -*- lexical-binding: t -*-
;;; Commentary:

;; Among settings for many aspects of `org-mode', this code includes
;; an opinionated setup for the Getting Things Done (GTD) system based
;; around the Org Agenda.  I have an "inbox.org" file with a header
;; including

;;     #+CATEGORY: Inbox
;;     #+FILETAGS: INBOX

;; and then set this file as `org-default-notes-file'.  Captured org
;; items will then go into this file with the file-level tag, and can
;; be refiled to other locations as necessary.

;; Those other locations are generally other org files, which should
;; be added to `org-agenda-files-list' (along with "inbox.org" org).
;; With that done, there's then an agenda view, accessible via the
;; `org-agenda' command, which gives a convenient overview.
;; `org-todo-keywords' is customised here to provide corresponding
;; TODO states, which should make sense to GTD adherents.

;;; Code:

(when *is-a-mac*
  (maybe-require-package 'grab-mac-link))

(maybe-require-package 'org-cliplink)

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(defvar sanityinc/org-global-prefix-map (make-sparse-keymap)
  "A keymap for handy global access to org helpers, particularly clocking.")

(define-key sanityinc/org-global-prefix-map (kbd "j") 'org-clock-jump-to-current-clock)
(define-key sanityinc/org-global-prefix-map (kbd "l") 'org-clock-in-last)
(define-key sanityinc/org-global-prefix-map (kbd "i") 'org-clock-in)
(define-key sanityinc/org-global-prefix-map (kbd "o") 'org-clock-out)
(define-key global-map (kbd "C-c o") sanityinc/org-global-prefix-map)


;; Various preferences
(setq org-log-done t
      org-edit-timestamp-down-means-later t
      org-hide-emphasis-markers t
      org-catch-invisible-edits 'show
      org-export-coding-system 'utf-8
      org-fast-tag-selection-single-key 'expert
      org-html-validation-link nil
      org-return-follows-link t
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-timestamp-if-done t
      org-export-kill-product-buffer-when-displayed t
      org-tags-column -80
      org-agenda-tags-column -80
      ;; This shows the ‘Seinfeld consistency’ graph closer to the habit heading.
      org-habit-graph-column 50
      org-clock-history-length 23
      org-clock-in-resume t
      org-archive-mark-done nil
      ;; Sometimes I change tasks I'm clocking quickly
      ;; ---this removes clocked tasks with 0:00 duration
      org-clock-out-remove-zero-time-clocks t
      ;; Clock out when moving task to a done state
      org-clock-out-when-done t
      ;; Save the running clock and all clock history
      ;; when exiting Emacs, load it on startup
      org-clock-persist t
      ;; Prompt to resume an active clock
      org-clock-persist-query-resume t
      ;; Include current clocking task in clock reports
      org-clock-report-include-clocking-task t
      ;; Show habits for every day in the agenda.
      org-habit-show-habits t
      org-habit-show-habits-only-for-today nil
      ;; Set archive location

(push '("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
      org-global-properties)

;; Lots of stuff from http://doc.norang.ca/org-mode.html

;; Re-align tags when window shape changes
(with-eval-after-load 'org-agenda
  (add-hook 'org-agenda-mode-hook
            (lambda () (add-hook
                   'window-configuration-change-hook
                   'org-agenda-align-tags nil t))))

;;----------------------------------------------------------------------------
;; Let's get some fancy bullets
;;----------------------------------------------------------------------------
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package toc-org
  ;; Automatically update toc when saving an Org file.
  :hook (org-mode . toc-org-mode)
  ;; Use both “:ignore_N:” and ":export_N:” to exlude headings from the TOC.
  :custom (toc-org-noexport-regexp
           "\\(^*+\\)\s+.*:\\(ignore\\|noexport\\)\\([@_][0-9]\\)?:\\($\\|[^ ]*?:$\\)"))


(use-package org-sticky-header
  :hook (org-mode . org-sticky-header-mode)
  :config
  (setq-default
   org-sticky-header-full-path 'full
   ;; Child and parent headings are seperated by a /.
   org-sticky-header-outline-path-separator " / "))

(defun rb/org-goto-line (line)
  "Go to the indicated LINE, unfolding the parent Org header.
Implementation: Go to the line, then look at the 1st previous org
header, now we can unfold it whence we do so, then we go back to
the line we want to be at."
  (interactive "nEnter line: ")
  (goto-line line)
  (org-previous-visible-heading 1)
  (org-cycle)
  (goto-line line))


(defun rb/org-fold-current-subtree-anywhere-in-it ()
  "Hide the current heading, while being anywhere inside it."
  (interactive)
  (save-excursion
    (org-narrow-to-subtree)
    (org-shifttab)
    (widen)))

(add-hook 'org-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-h") 'rb/org-fold-current-subtree-anywhere-in-it)
             (local-set-key (kbd "M-g M-g") 'rb/org-goto-line)))

(defvar init-rb-org-at-src-begin -1
  "Variable that holds whether last position was a.")

(defvar init-rb-ob-header-symbol ?☰
  "Symbol used for babel headers.")

(defun rb-org-prettify-src--update ()
  (let ((case-fold-search t)
        (re "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*")
        found)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward re nil t)
        (goto-char (match-end 0))
        (let ((args (org-trim
                     (buffer-substring-no-properties (point)
                                                     (line-end-position)))))
          (when (org-string-nw-p args)
            (let ((new-cell (cons args init-rb-ob-header-symbol)))
              (cl-pushnew new-cell prettify-symbols-alist :test #'equal)
              (cl-pushnew new-cell found :test #'equal)))))
      (setq prettify-symbols-alist
            (cl-set-difference prettify-symbols-alist
                               (cl-set-difference
                                (cl-remove-if-not
                                 (lambda (elm)
                                   (eq (cdr elm) init-rb-ob-header-symbol))
                                 prettify-symbols-alist)
                                found :test #'equal)))
      ;; Clean up old font-lock-keywords.
      (font-lock-remove-keywords nil prettify-symbols--keywords)
      (setq prettify-symbols--keywords (prettify-symbols--make-keywords))
      (font-lock-add-keywords nil prettify-symbols--keywords)
      (while (re-search-forward re nil t)
        (font-lock-flush (line-beginning-position) (line-end-position))))))

(defun init-rb-org-prettify-src ()
  "Hide src options via `prettify-symbols-mode'.

  `prettify-symbols-mode' is used because it has uncollpasing.
  It's may not be efficient."
  (let* ((case-fold-search t)
         (at-src-block (save-excursion
                         (beginning-of-line)
                         (looking-at "^[ \t]*#\\+begin_src[ \t]+[^ \f\t\n\r\v]+[ \t]*"))))
    ;; Test if we moved out of a block.
    (when (or (and init-rb-org-at-src-begin
                   (not at-src-block))
              ;; File was just opened.
              (eq init-rb-org-at-src-begin -1))
      (rb-org-prettify-src--update))
    (setq init-rb-org-at-src-begin at-src-block)))

(defun init-rb-org-prettify-symbols ()
  "Prettify source code openers in `org-mode'."
  (mapc (apply-partially 'add-to-list 'prettify-symbols-alist)
        (cl-reduce 'append
                   (mapcar (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                           `(("#+begin_src" . ?✎) ;; ➤ 🖝 ➟ ➤ ✎
                             ("#+end_src"   . ?□) ;; ⏹
                             ("#+header:" . ,init-rb-ob-header-symbol)
                             ("#+begin_quote" . ?»)
                             ("#+end_quote" . ?«)))))
  (turn-on-prettify-symbols-mode)
  (add-hook 'post-command-hook 'init-rb-org-prettify-src t t))


(add-hook 'org-mode-hook #'init-rb-org-prettify-symbols)

(global-prettify-symbols-mode)

(defvar rb/prettify-alist nil
  "Musa's personal prettifications.")

(cl-loop for pair in '(;; Example of how pairs like this to beautify org block delimiters
                       ("#+begin_example" . (?ℰ (Br . Bl) ?⇒)) ;; ℰ⇒
                       ("#+end_example"   . ?⇐)                 ;; ⇐
                       ("<=" . ?≤) (">=" . ?≥)
                       ("->" . ?→) ("-->". ?⟶) ;; threading operators
                       ("[ ]" . ?□) ("[X]" . ?☑) ("[-]" . ?◐)) ;; Org checkbox symbols

         do (push pair rb/prettify-alist))

(cl-loop for hk in '(text-mode-hook prog-mode-hook org-mode-hook)
         do (add-hook hk (lambda ()
                           (setq prettify-symbols-alist
                                 (append rb/prettify-alist prettify-symbols-alist)))))

(setq prettify-symbols-unprettify-at-point 'right-edge)

(use-package org-pretty-tags
  :diminish org-pretty-tags-mode
  :demand t
  :config
  (setq org-pretty-tags-surrogate-strings
        '(("Neato"    . "💡")
          ("Blog"     . "✍")
          ("Audio"    . "♬")
          ("Video"    . "📺")
          ("Book"     . "📚")
          ("Running"  . "🏃")
          ("Question" . "❓")
          ("Wife"     . "💕")
          ("Text"     . "💬") ; 📨 📧
          ("Friends"  . "👪")
          ("Self"     . "🍂")
          ("Finances" . "💰")
          ("Car"      . "🚗") ; 🚙 🚗 🚘
          ("Urgent"   . "🔥"))) ;; 📥 📤 📬
  (org-pretty-tags-global-mode 1))

(setq org-lowest-priority ?D) ;; Now org-speed-eky ‘,’ gives 4 options
(setq org-priority-faces
      '((?A :foreground "red" :weight bold)
        (?B :foreground "orange" :weight bold-italic)
        (?C :foreground "yellow" :weight bold-italic)
        (?D :foreground "green" :weight bold-italic)))

(use-package org-fancy-priorities
  :diminish t
  :hook   (org-mode . org-fancy-priorities-mode)
  :custom (org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL")))

;; Tasks get a 25 minute count down timer
(setq org-timer-default-timer 25)

;; Use the timer we set when clocking in happens.
(add-hook 'org-clock-in-hook
          (lambda () (org-timer-set-timer '(16))))

;; unless we clocked-out with less than a minute left,
;; show disappointment message.
(add-hook 'org-clock-out-hook
          (lambda ()
            (unless (s-prefix? "0:00" (org-timer-value-string))
              (message-box "The basic 25 minutes on this difficult task are not up; it's a shame to see you leave."))
            (org-timer-stop)))

(setq org-log-note-clock-out t)

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)

;; Show lot of clocking history



(maybe-require-package 'writeroom-mode)

(define-minor-mode prose-mode
  "Set up a buffer for prose editing.
This enables or modifies a number of settings so that the
experience of editing prose is a little more like that of a
typical word processor."
  nil " Prose" nil
  (if prose-mode
      (progn
        (when (fboundp 'writeroom-mode)
          (writeroom-mode 1))
        (setq truncate-lines nil)
        (setq word-wrap t)
        (setq cursor-type 'bar)
        (when (eq major-mode 'org)
          (kill-local-variable 'buffer-face-mode-face))
        (buffer-face-mode 1)
        ;;(delete-selection-mode 1)
        (setq-local blink-cursor-interval 0.6)
        (setq-local show-trailing-whitespace nil)
        (setq-local line-spacing 0.2)
        (setq-local electric-pair-mode nil)
        (ignore-errors (flyspell-mode 1))
        (visual-line-mode 1))
    (kill-local-variable 'truncate-lines)
    (kill-local-variable 'word-wrap)
    (kill-local-variable 'cursor-type)
    (kill-local-variable 'blink-cursor-interval)
    (kill-local-variable 'show-trailing-whitespace)
    (kill-local-variable 'line-spacing)
    (kill-local-variable 'electric-pair-mode)
    (buffer-face-mode -1)
    ;; (delete-selection-mode -1)
    (flyspell-mode -1)
    (visual-line-mode -1)
    (when (fboundp 'writeroom-mode)
      (writeroom-mode 0))))

;;(add-hook 'org-mode-hook 'buffer-face-mode)


(setq org-support-shift-select t)

;;; Capturing

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      `(("t" "todo" entry (file "")  ; "" => `org-default-notes-file'
         "* NEXT %?\n%U\n" :clock-resume t)
        ("n" "note" entry (file "")
         "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
        ))



;;; Refiling

(setq org-refile-use-cache nil)

;; Log note/time whenever we do a refile
(setq org-log-refile 'note)

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))

(with-eval-after-load 'org-agenda
  (add-to-list 'org-agenda-after-show-hook 'org-show-entry))

(advice-add 'org-refile :after (lambda (&rest _) (org-save-all-org-buffers)))

;; Exclude DONE state tasks from refile targets
(defun sanityinc/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'sanityinc/verify-refile-target)

(defun sanityinc/org-refile-anywhere (&optional goto default-buffer rfloc msg)
  "A version of `org-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-refile goto default-buffer rfloc msg)))

(defun sanityinc/org-agenda-refile-anywhere (&optional goto rfloc no-update)
  "A version of `org-agenda-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-agenda-refile goto rfloc no-update)))

;; Targets start with the file name - allows creating level 1 tasks
;;(setq org-refile-use-outline-path (quote file))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)


;;; To-do settings

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d@)" "CANCELLED(c@)")
              (sequence "HABIT(a@)" "ROUTINE(r@)" "|" "DONE(d@)" "CANCELLED(c@)")
              (sequence "PROJECT(p@)" "|" "STARTED(s@)" "DONE(d@)" "CANCELLED(c@)")
              (sequence "WAITING(w@)" "DELEGATED(e@)" "HOLD(h@)" "|" "CANCELLED(c@)")))
      org-todo-repeat-to-state "NEXT")

(setq org-todo-keyword-faces
      (quote (("NEXT" :inherit warning)
              ("DONE" :inherit font-lock-comment-face)
              ("STEP_6" . (:foreground "red" :weight bold))
              ("HABIT" . (:foreground "coral" :weight bold))
              ("Q2" . (:foreground "magenta3" :weight bold))
              ("Q3" . (:foreground "DeepPink" :weight bold))
              ("Q4" . (:foreground "OrangeRed" :weight bold))
              ("STEP_4" . (:foreground "coral" :weight bold))
              ("Q1" . (:foreground "SeaGreen1" :weight bold))
              ("TODO" . (:foreground "LimeGreen" :weight bold))
              ("GOAL" . (:foreground "turquoise1" :weight bold))
              ("HOLD" . (:foreground "chocolate4" :weight bold))
              ("STEP_5" . (:foreground "OrangeRed" :weight bold))
              ("STARTED" . (:foreground "magenta3" :weight bold))
              ("STEP_2" . (:foreground "IndianRed" :weight bold))
              ("PLANNER" . (:foreground "LimeGreen" :weight bold))
              ("LIFE_GOAL" . (:foreground "SkyBlue" :weight bold))
              ("STEP_3" . (:foreground "IndianRed1" :weight bold))
              ("WAITING" . (:foreground "firebrick4" :weight bold))
              ("CANCELLED" . (:foreground "DeepPink" :weight bold))
              ("ROUTINE" . (:foreground "PaleGreen1" :weight bold))
              ("PROJECT" . (:foreground "DodgerBlue1" :weight bold))
              ("DELEGATED" . (:foreground "turquoise1" :weight bold))
              ("ALL_YEAR" . (:foreground "systemBlueColor" :weight bold))
              )))



;;; Agenda views

(setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))


(let ((active-project-match "-INBOX/PROJECT"))

  (setq org-stuck-projects
        `(,active-project-match ("NEXT")))

  (setq org-agenda-compact-blocks t
        org-agenda-sticky t
        org-agenda-start-on-weekday nil
        org-agenda-span 'day
        org-agenda-include-diary nil
        org-agenda-sorting-strategy
        '((agenda habit-down time-up user-defined-up effort-up category-keep)
          (todo category-up effort-up)
          (tags category-up effort-up)
          (search category-up))
        org-agenda-window-setup 'current-window
        org-agenda-custom-commands
        `(("N" "Notes" tags "NOTE"
           ((org-agenda-overriding-header "Notes")
            (org-tags-match-list-sublevels t)))
          ("g" "GTD"
           ((agenda "" nil)
            (tags "INBOX"
                  ((org-agenda-overriding-header "Inbox")
                   (org-tags-match-list-sublevels nil)))
            (stuck ""
                   ((org-agenda-overriding-header "Stuck Projects")
                    (org-agenda-tags-todo-honor-ignore-options t)
                    (org-tags-match-list-sublevels t)
                    (org-agenda-todo-ignore-scheduled 'future)))
            (tags-todo "-INBOX"
                       ((org-agenda-overriding-header "Next Actions")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("HOLD" "WAITING"))
                                (org-agenda-skip-entry-if 'nottodo '("NEXT")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(todo-state-down effort-up category-keep))))
            (tags-todo ,active-project-match
                       ((org-agenda-overriding-header "Projects")
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX/-NEXT"
                       ((org-agenda-overriding-header "Orphaned Tasks")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("PROJECT" "HOLD" "WAITING" "DELEGATED"))
                                (org-agenda-skip-subtree-if 'nottododo '("TODO")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/WAITING"
                       ((org-agenda-overriding-header "Waiting")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/DELEGATED"
                       ((org-agenda-overriding-header "Delegated")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX"
                       ((org-agenda-overriding-header "On Hold")
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("WAITING"))
                                (org-agenda-skip-entry-if 'nottodo '("HOLD")))))
                        (org-tags-match-list-sublevels nil)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            ;; (tags-todo "-NEXT"
            ;;            ((org-agenda-overriding-header "All other TODOs")
            ;;             (org-match-list-sublevels t)))
            )))))


(add-hook 'org-agenda-mode-hook 'hl-line-mode)


;;; Org clock

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(with-eval-after-load 'org
  (org-clock-persistence-insinuate))
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Save state changes in the LOGBOOK drawer
(setq org-log-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show clock sums as hours and minutes, not "n days" etc.
(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))



;;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(with-eval-after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))



(when (and *is-a-mac* (file-directory-p "/Applications/org-clock-statusbar.app"))
  (add-hook 'org-clock-in-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                     (concat "tell application \"org-clock-statusbar\" to clock in \"" org-clock-current-task "\""))))
  (add-hook 'org-clock-out-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                     "tell application \"org-clock-statusbar\" to clock out"))))



;; TODO: warn about inconsistent items, e.g. TODO inside non-PROJECT
;; TODO: nested projects!




(require-package 'org-pomodoro)
(setq org-pomodoro-keep-killed-pomodoro-time t)
(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil)
    (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   `((R . t)
     (ditaa . t)
     (dot . t)
     (emacs-lisp . t)
     (gnuplot . t)
     (haskell . nil)
     (latex . t)
     (ledger . t)
     (ocaml . nil)
     (octave . t)
     (plantuml . t)
     (python . t)
     (ruby . t)
     (screen . nil)
     (,(if (locate-library "ob-sh") 'sh 'shell) . t)
     (sql . t)
     (sqlite . t))))

(require 'org-tempo)

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(defun org-global-props (&optional rb/property)
  "Get the plists of global org properties of current buffer."
  (interactive)
  (unless rb/property (setq rb/property "PROPERTY"))
  (org-element-map (org-element-parse-buffer)
      'keyword (lambda (el) (when (string-match rb/property (org-element-property :key el)) el))))

(defun org-global-prop-value (key)
  "Get global org property KEY of current buffer."
  (org-element-property :value (car (org-global-props key))))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  "Used to tangle org file when it change."
  (when (or (string-equal (file-name-directory (buffer-file-name))
                          (expand-file-name user-emacs-directory))
            (equal (org-global-prop-value "CATEGORY") "Configuration"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(when (not (file-exists-p "~/.emacs.d/plantuml.jar"))
  (shell-command-to-string
   "curl -LO https://downloads.sourceforge.net/project/plantuml/plantuml.jar")
  (unless (file-exists-p "~/.emacs.d/plantuml.jar")
    (shell-command-to-string
     "mv plantuml.jar ~/.emacs.d/")))

(when (file-exists-p "~/.emacs.d/plantuml.jar")
  (setq org-plantuml-jar-path
        (expand-file-name  "~/.emacs.d/plantuml.jar"))

  (setq org-confirm-babel-evaluate nil))
;;----------------------------------------------------------------------------
;; I'm making the checkbox feature work with bullets as well as the normal way.
;; I copied this code from Sasha Chua at:
;; https://sachachua.com/blog/2008/01/outlining-your-notes-with-org/
;;----------------------------------------------------------------------------
(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and
update them with the current numbers.  With optional prefix
argument ALL, do this for the whole buffer."
  (interactive "P")
  (save-excursion
    (let* (              ; (buffer-invisibility-spec (org-inhibit-invisibility))
           (beg (condition-case nil
                    (progn (outline-back-to-heading) (point))
                  (error (point-min))))
           (end (move-marker
                 (make-marker)
                 (progn (or (outline-get-next-sibling) ;; (1)
                            (goto-char (point-max)))
                        (point))))
           (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
           (re-box
            "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
           b1 e1 f1 c-on c-off lim (cstat 0))
      (when all
        (goto-char (point-min))
        (or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
        (setq beg (point) end (point-max)))
      (goto-char beg)
      (while (re-search-forward re end t)
        (setq cstat (1+ cstat)
              b1 (match-beginning 0)
              e1 (match-end 0)
              f1 (match-beginning 1)
              lim (cond
                   ((org-on-heading-p)
                    (or (outline-get-next-sibling) ;; (3)
                        (goto-char (point-max)))
                    (point))
                   ((org-at-item-p) (org-end-of-item) (point))
                   (t nil))
              c-on 0 c-off 0)
        (goto-char e1)
        (when lim
          (while (re-search-forward re-box lim t)
            (if (member (match-string 2) '("[ ]" "[-]"))
                (setq c-off (1+ c-off))
              (setq c-on (1+ c-on))))
          (goto-char b1)
          (insert (if f1
                      (format "[%d%%]" (/ (* 100 c-on)
                                          (max 1 (+ c-on c-off))))
                    (format "[%d/%d]" c-on (+ c-on c-off))))
          (and (looking-at "\\[.*?\\]")
               (replace-match ""))))
      (when (interactive-p)
        (message "Checkbox statistics updated %s (%d places)"
                 (if all "in entire file" "in current outline entry")
                 cstat)))))
(defadvice org-update-checkbox-count (around wicked activate)
  "Fix the built-in checkbox count to understand headlines."
  (setq ad-return-value
        (wicked/org-update-checkbox-count (ad-get-arg 1))))

;;----------------------------------------------------------------------------
;;----------------------------------------------------------------------------

;; Set org-modules I want to use
(setq org-modules
      '(ol-bbdb
        ol-bibtex
        org-crypt
        ol-docview
        ol-eww
        ol-gnus
        org-habit
        ol-info
        ol-irc
        ol-rmail
        ol-w3m
        ol-eshell))

(when (not (directory-name-p "~/.emacs.d/site-lisp/org-appear"))
  (shell-command-to-string
   "git clone git@github.com:awth13/org-appear.git ~/.emacs.d/site-lisp/org-appear")
  (require 'org-appear "~/.emacs.d/site-lisp/org-appear/org-appear.el")
  (add-hook 'org-mode-hook 'org-appear-mode))

;; This allows you to tell org-babel to tangle you org files after
;; save by placing:
;; #+CATEGORY: Configuration
;; in the head of the org file.
;; Change this search key/term to what best suits the individual
(setq efs/tangle-search-key "CATEGORY")
(setq efs/tangle-search-term "Configuration")

(defun efs/org-global-props (&optional efs/property)
  "Get the plists of global org properties of current buffer."
  (interactive)
  (unless efs/property (setq efs/property "PROPERTY"))
  (org-element-map (org-element-parse-buffer)
      'keyword (lambda (el) (when (string-match efs/property (org-element-property :key el)) el))))

(defun efs/org-global-prop-value (key)
  "Get global org property KEY of current buffer."
  (org-element-property :value (car (efs/org-global-props key))))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  "Used to tangle org file when it change."
  (when (or (string-equal (file-name-directory (buffer-file-name))
                          (expand-file-name user-emacs-directory))
            (string-equal (efs/org-global-prop-value efs/tangle-search-key) efs/tangle-search-term))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(provide 'init-org)
;;; init-org.el ends here
