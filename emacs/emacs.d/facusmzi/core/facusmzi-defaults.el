;;; facusmzi-defaults --- sane defaults -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(setq make-backup-files nil
      auto-save-default nil)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(setq savehist-file "~/.local/share/emacs/history")
(savehist-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
(column-number-mode)

(provide 'facusmzi-defaults)
;;; facusmzi-defaults.el ends here
