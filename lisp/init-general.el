;;; init-general.el --- Provides shell  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package general
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "S-SPC")
  (efs/leader-keys
    "t"  '(:ignore t :which-key "TOGGLES")
    "tt" '(counsel-load-theme :which-key "Choose Theme")
    "tl" '(toggle-truncate-lines :which-key "Toggle Truncate Lines")))

(unless (package-installed-p 'hydra)
  (package-install 'hydra))

(defun rb/kill-del ()
  "Kill buffer and delete window."
  (interactive)
  (kill-this-buffer)
  (delete-window))
;;--------------------------------------------------------------------------------
;; Use ijkl to denote ↑←↓→ arrows.
;;--------------------------------------------------------------------------------
(defhydra hydra-windows (global-map    "C-c w"            )
  "Choose Window Function:"
  ("b" balance-windows             "Balance"              )
  ("i" enlarge-window              "Heighten"             )
  ("e" shrink-window-horizontally  "Narrow"               )
  ("q" shrink-window               "Lower"                )
  ("m" enlarge-window-horizontally "Widen"                )
  ("a" ace-window                  "Number Based"         )
  ("r" rb/kill-del                 "Kill and Delete"      )
  ("d" delete-window               "Delete Window"        )
  ("s" split-window-vertically     "Horizontal Split"     )
  ("v" split-window-horizontally   "Vertical Split"       )
  ("h" windmove-left               "Move Left"            )
  ("j" windmove-down               "Move Down"            )
  ("k" windmove-up                 "Move Up"              )
  ("l" windmove-right              "Move Right"           )
  ("c" switch-window-then-swap-buffer  "Swap" :color teal))

(efs/leader-keys
  "w" '(hydra-windows/body :which-key "WINDOW FUNCTIONS"))

(defhydra hydra-buffers                (:timeout 20)
  "Choose Buffer Function:"
  ("c" persp-counsel-switch-buffer "Choose Buffer")
  ("h" buffer-flip-backward        "Backward"     )
  ("k" kill-this-buffer            "Kill Buffer"  )
  ("l" buffer-flip-forward         "Forward"      )
  ("f" nil "Finished"              :exit t       ))

(efs/leader-keys
  "b" '(hydra-buffers/body :which-key "BUFFER FUNCTIONS"))

(defhydra hydra-text-scale (:timeout 4)
  "Scale Text:"
  ("j" text-scale-increase "In")
  ("k" text-scale-decrease "Out")
  ("f" nil "Finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "SCALE TEXT"))

(defhydra hydra-projectile (:timeout 20)
  "Projectile Mode:"
  ("p" projectile-persp-switch-project   "Projectile Switch Project" )
  ("l" projectile-find-file              "Projectile Find File"      )
  ("k" projectile-project-run-cmd        "Projectile Run Project"    )
  ("t" projectile-project-test-cmd       "Projectile test Project"   )
  ("g" projectile-ripgrep                "Projectile Ripgrep Search" )
  ("m" projectile-commander              "Projectile Commander"      )
  ("a" persp-add-buffer                  "Perspective Add Buffer"    )
  ("s" persp-switch                      "Perspective Switch Project")
  ("r" persp-rename                      "Rename Perspective Tab"    )
  ("f" nil "Finished"                    :exit  t                   ))

(efs/leader-keys
  "p" '(hydra-projectile/body :which-key "Perspective and Projectile"))
(provide 'init-general)
;;; init-general.el ends here
