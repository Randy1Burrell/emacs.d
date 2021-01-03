;;; init-hydra.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;--------------------------------------------------------------------------------
;; Invoke all possible key extensions having a common prefix by
;; supplying the prefix only once.
;;--------------------------------------------------------------------------------
(unless (package-installed-p 'hydra)
  (package-install 'hydra))

;;--------------------------------------------------------------------------------
;; Neato doc strings for hydras
;;--------------------------------------------------------------------------------
(unless (package-installed-p 'pretty-hydra)
  (package-install 'pretty-hydra))
;;--------------------------------------------------------------------------------
;; Hydra: Supply a prefix only once:2 ends here
;;--------------------------------------------------------------------------------

;;--------------------------------------------------------------------------------
;; Use ijkl to denote ↑←↓→ arrows.
;;--------------------------------------------------------------------------------
(defhydra hydra-windows (global-map    "C-c w"   )
  ("b" balance-windows                 "balance" )
  ("i" enlarge-window                  "heighten")
  ("j" shrink-window-horizontally      "narrow"  )
  ("k" shrink-window                   "lower"   )
  ("l" enlarge-window-horizontally     "widen"   )
  ("s" switch-window-then-swap-buffer  "swap" :color teal))

(defhydra perspective (global-map    "C-c y"   )
  ("a" persp-add-new              "add new persp")
  ("p" persp-mode                 "persp mode"   )
  ("s" persp-switch               "switch"       ))

(provide 'init-hydra)
;;; init-hydra.el ends here
