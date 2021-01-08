;;; init-org-helpers.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

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

(provide 'init-org-helpers)
;;; init-org-helpers.el ends here
