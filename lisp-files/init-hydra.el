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

(provide 'init-hydra)
;;; init-hydra.el ends here
