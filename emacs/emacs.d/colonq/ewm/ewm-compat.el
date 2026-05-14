;;; ewm-compat.el --- EXWM compatibility for EWM -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'ewm-config)

(defalias 'exwm-workspace-switch 'tab-bar-select-tab)
(defalias 'exwm-workspace-switch-create 'tab-new)
(defalias 'exwm-layout-toggle-fullscreen 'ewm-toggle-fullscreen)
(defalias 'exwm-input-set-key (lambda (key cmd) (define-key ewm-mode-map key cmd)))
(defalias 'exwm-workspace-move-window 'ignore)
(defalias 'exwm-randr-refresh 'ignore)

(defun colonq/ewm-workspace-next () (interactive) (ewm-windmove-right))
(defun colonq/ewm-workspace-prev () (interactive) (ewm-windmove-left))
(defun colonq/ewm-workspace-number () (1+ (tab-bar--current-tab-index)))
(defun colonq/ewm-id->buffer (id) (gethash id ewm--surfaces))
(defun colonq/ewm-show-outputs () (interactive) (ewm-list-outputs))

(provide 'ewm-compat)
;;; ewm-compat.el ends here
