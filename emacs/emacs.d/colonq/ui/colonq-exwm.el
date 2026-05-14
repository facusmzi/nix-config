;;; colonq-ewm --- Wayland window manager -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'colonq-package)
(require 'colonq-hydra)

;; Cargar el módulo dinámico de EWM
(unless (featurep 'ewm-core)
  (let ((path (getenv "EWM_MODULE_PATH")))
    (if (and path (file-exists-p path))
        (module-load path)
      (require 'ewm-core))))

(require 'ewm)

;;; Multi-monitor
;; EWM crea un frame por output automáticamente via ewm--handle-output-detected.
;; La configuración de outputs va en ewm-output-config.
;; Ajustá los nombres de tus conectores con M-x ewm-list-outputs.
(setopt ewm-output-config
        '(("eDP-1"  :x 0   :y 0)
          ("HDMI-1" :x 1920 :y 0)))

(defun colonq/other-monitor ()
  "Switch focus to the other monitor."
  (interactive)
  (let* ((current-output (frame-parameter nil 'ewm-output))
         (other-frame
          (cl-find-if
           (lambda (f)
             (and (frame-parameter f 'ewm-output)
                  (not (equal (frame-parameter f 'ewm-output)
                              current-output))))
           (frame-list))))
    (if other-frame
        (select-frame-set-input-focus other-frame)
      (message "No other monitor found"))))

;;; Eyebrowse helpers (sin cambios respecto a colonq-exwm)

(defvar colonq/saved-eyebrowse-config nil)

(defun colonq/save-eyebrowse-config ()
  "Save the current eyebrowse window config."
  (interactive)
  (let* ((current-slot (eyebrowse--get 'current-slot))
         (window-configs (eyebrowse--get 'window-configs))
         (current-tag (nth 2 (assoc current-slot window-configs))))
    (setq colonq/saved-eyebrowse-config
          (eyebrowse--current-window-config current-slot current-tag))))

(defun colonq/reload-eyebrowse-config ()
  "Reload the saved eyebrowse window config."
  (interactive)
  (when colonq/saved-eyebrowse-config
    (let ((current-slot (eyebrowse--get 'current-slot)))
      (eyebrowse--update-window-config-element
       (cons current-slot (cdr colonq/saved-eyebrowse-config)))
      (eyebrowse--load-window-config current-slot))))

(defun colonq/lock-window ()
  "Toggle whether the current window is dedicated."
  (interactive)
  (let* ((win (get-buffer-window (current-buffer)))
         (new (not (window-dedicated-p win))))
    (set-window-dedicated-p win new)
    (message "Window dedicated: %s" (if new "yes" "no"))))

;;; Keybindings

;; q abre el dispatcher desde cualquier superficie
(define-key ewm-mode-map (kbd "q") #'colonq/dispatcher)
(define-key ewm-mode-map (kbd "Q") #'colonq/other-monitor)

;; Navegación de ventanas desde superficies Wayland
(define-key ewm-mode-map (kbd "M-h") #'windmove-left)
(define-key ewm-mode-map (kbd "M-l") #'windmove-right)
(define-key ewm-mode-map (kbd "M-k") #'windmove-up)
(define-key ewm-mode-map (kbd "M-j") #'windmove-down)
(define-key ewm-mode-map (kbd "M-H") #'buf-move-left)
(define-key ewm-mode-map (kbd "M-L") #'buf-move-right)
(define-key ewm-mode-map (kbd "M-K") #'buf-move-up)
(define-key ewm-mode-map (kbd "M-J") #'buf-move-down)

;; Asegurar que q se intercepte cuando una superficie tiene foco
(setopt ewm-intercept-prefixes
        (append ewm-intercept-prefixes
                '(?\q)))

;;; Iniciar EWM
(ewm-start-module)

(provide 'colonq-ewm)
;;; colonq-ewm ends here
