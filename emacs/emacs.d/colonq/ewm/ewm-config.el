;;; ewm-config.el --- EWM configuration for Colonq -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'cl-lib)
(require 'ewm)

;;; Module loading
(defvar colonq/ewm-module-path
  (or (getenv "EWM_MODULE_PATH")
      (expand-file-name "~/Documentos/emacs/colonq/ewm/target/release/libewm_core.so"))
  "Path to EWM core module.")

(defun colonq/load-ewm-module ()
  "Load EWM dynamic module."
  (unless (featurep 'ewm-core)
    (when (file-exists-p colonq/ewm-module-path)
      (module-load colonq/ewm-module-path)
      (require 'ewm))))

;;; EWM mode map
(defvar colonq/ewm-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s-<left>")  #'ewm-windmove-left)
    (define-key map (kbd "s-<right>") #'ewm-windmove-right)
    (define-key map (kbd "s-<down>")  #'windmove-down)
    (define-key map (kbd "s-<up>")    #'windmove-up)
    (define-key map (kbd "s-t")       #'tab-new)
    (define-key map (kbd "s-w")       #'tab-close)
    (define-key map (kbd "s-<tab>")   #'ewm-next-surface-buffer)
    (define-key map (kbd "s-S-<tab>") #'ewm-prev-surface-buffer)
    (define-key map (kbd "s-<iso-lefttab>") #'ewm-prev-surface-buffer)
    (define-key map (kbd "s-f") #'ewm-toggle-fullscreen)
    (define-key map (kbd "s-l") #'ewm-lock-session)
    (define-key map (kbd "s-d") #'ewm-launch-app)
    (define-key map (kbd "s-c") #'kill-ring-save)
    (define-key map (kbd "s-v") #'yank)
    (define-key map (kbd "<print>") #'colonq/snip)
    (define-key map (kbd "S-<print>") #'colonq/screenshot)
    (dotimes (i 9)
      (define-key map (kbd (format "s-%d" (1+ i))) #'ewm-tab-select-or-return))
    map)
  "Keymap for EWM mode.")

(defcustom colonq/ewm-intercept-prefixes
  '(?\C-x ?\C-u ?\C-h ?\M-x ?\M-` ?\C-g ?\C-\[
    ("<f12>" :fullscreen)
    ("<MonBrightnessUp>" :fullscreen)
    ("<MonBrightnessDown>" :fullscreen)
    ("<AudioRaiseVolume>" :fullscreen)
    ("<AudioLowerVolume>" :fullscreen)
    ("<AudioMute>" :fullscreen))
  "Keys intercepted when Wayland surface has focus."
  :type '(repeat (choice character string (list (choice character string) (const :fullscreen))))
  :group 'colonq)

(defcustom colonq/ewm-emulate-keys
  '((?\s-c . "ctrl") (?\s-v . "ctrl") (?\s-x . "ctrl") (?\s-z . "ctrl") (?\s-a . "ctrl"))
  "Super+KEY translated to modifier+KEY for non-Emacs surfaces."
  :type '(alist :key-type character :value-type string)
  :group 'colonq)

(defun colonq/ewm-start ()
  "Start EWM compositor."
  (interactive)
  (colonq/load-ewm-module)
  (when (and (fboundp 'ewm-running) (ewm-running))
    (user-error "EWM already running"))
  (setq ewm-mode-map colonq/ewm-mode-map)
  (setq ewm-intercept-prefixes colonq/ewm-intercept-prefixes)
  (setq ewm-surface-emulate-keys colonq/ewm-emulate-keys)
  (setq ewm-focus-follows-mouse colonq/focus-follows-mouse)
  (setq ewm-mouse-follows-focus colonq/mouse-follows-focus)
  (ewm-start-module)
  (ewm-mode 1)
  (message "EWM started"))

(defun colonq/ewm-stop ()
  "Stop EWM compositor."
  (interactive)
  (when (and (fboundp 'ewm-running) (ewm-running))
    (ewm-stop-module)
    (ewm-mode -1))
  (message "EWM stopped"))

(defun colonq/ewm-dispatcher-setup ()
  "Setup for colonq-dispatcher."
  (setq colonq/contextual-ide (lambda () (interactive) (message "EWM active")))
  (setq colonq/contextual-lookup 'ewm-list-outputs)
  (setq colonq/contextual-quit 'colonq/ewm-stop))

(provide 'ewm-config)
;;; ewm-config.el ends here
