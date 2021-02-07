;;; init-security.el --- Security tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code

(setq epg-gpg-program "gpg2")
(setenv "GPG_AGENT_INFO" nil)
(setq auth-sources '("~/.emacs.d/secrets/.authinfo.gpg"))

(provide 'init-security)
;;; init-security..el ends here
