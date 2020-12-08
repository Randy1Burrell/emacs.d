;;; init-defaults.el --- Support defaults -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;--------------------------------------------------------------------------------
;; Invoke all possible key extensions having a common prefix by
;; supplying the prefix only once.
;;--------------------------------------------------------------------------------
(use-package hydra)

;;--------------------------------------------------------------------------------
;; Neato doc strings for hydras
;;--------------------------------------------------------------------------------
(use-package pretty-hydra
  :ensure t)
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

(provide 'init-hydra)
;;; init-hydra.el ends here
