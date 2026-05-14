;;; colonq-ewm.el --- EWM backend for Colonq -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'colonq-package)
(require 'colonq-hydra)
(require 'ewm-config)
(require 'ewm-compat)

(defun colonq/ewm-setup ()
  (colonq/ewm-start)
  (setq colonq/contextual-ide 'colonq/ewm-dispatcher-setup))

(add-hook 'after-init-hook #'colonq/ewm-setup)

(provide 'colonq-ewm)
;;; colonq-ewm.el ends here
