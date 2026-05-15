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

;;; Iniciar EWM después de que todo init.el haya cargado
(add-hook 'after-init-hook #'ewm-start-module)

(provide 'colonq-ewm)
;;; colonq-ewm ends here
