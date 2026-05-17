;;; user-ewm.el --- EWM compositor Wayland -*- lexical-binding: t -*-

;; EWM usa Emacs como compositor Wayland. Los keybinds con Super (s-)
;; se interceptan antes de llegar a las apps Wayland, funcionando
;; globalmente igual que los de un WM tradicional.



;; EWM gestiona su propio teclado; el xkb de configuration.nix no aplica acá.
(setopt ewm-input-config
        '((touchpad :natural-scroll t
                    :tap t
                    :dwt t)
          (mouse :accel-profile "adaptive")
	  (trackpoint :accel-speed 0.3)
          (keyboard :repeat-delay 200
                    :repeat-rate 30  
                    :xkb-layouts  "latam" 
                    :xkb-options  "ctrl:nocaps")))



(use-package ewm
  :config
  ;; Activar input method en campos de texto de apps Wayland
  ;; (Firefox URL bar, Discord, etc.) — sin esto no podés tipear en ellas.
  (ewm-text-input-auto-mode-enable)

  :custom
  (ewm-mouse-follows-focus t)
  (ewm-unfocused-alpha 0.85)
  ;; Prefijos interceptados globalmente (aplican en cualquier app Wayland)
  (setopt ewm-surface-emulate-keys
          '((?\s-c . "ctrl")
            (?\s-v . "ctrl")))

  ;; Teclas individuales interceptadas globalmente.
  ;; M-w: copia desde Emacs al clipboard del sistema → pegable en Firefox etc.
  ;; s-c/s-y: atajos de estilo WM para copy/paste entre apps.
  (setopt ewm-intercept-prefixes
          '("C-x" "C-u" "C-h" "M-x"))


  ;; Ajustá los nombres de salida con: wlr-randr
  (ewm-output-config
   '(("eDP-1"    :x 0    :y 0 :scale 1.0)
     ("HDMI-A-1" :x 1920 :y 0 :scale 1.0)))

  :bind (:map ewm-mode-map
              ;; Navegación de ventanas (vim-style)
              ("s-h"        . windmove-left)
              ("s-l"        . windmove-right)
              ("s-k"        . windmove-up)
              ("s-j"        . windmove-down)
              ;; Mover ventanas
              ("s-H"        . windmove-swap-states-left)
              ("s-L"        . windmove-swap-states-right)
              ("s-K"        . windmove-swap-states-up)
              ("s-J"        . windmove-swap-states-down)
              ;; Splits
              ("s-|"        . (lambda () (interactive) (split-window-right) (other-window 1) (eat)))
              ("s--"        . (lambda () (interactive) (split-window-below) (other-window 1) (eat)))
              ("s-w"        . delete-window)
              ("s-="        . balance-windows)
              ;; Copy/paste entre apps Wayland (pgtk sincroniza con wl-clipboard)
              ("s-c"        . kill-ring-save)
              ("s-v"        . yank)
              ;; Buffers y proyectos
              ("s-d"        . consult-buffer)
              ("s-f"        . projectile-find-file)
              ("s-p"        . projectile-switch-project)
              ;; Apps
              ("s-t"        . eat)
              ("s-b"        . (lambda () (interactive)
                                (start-process "firefox" nil "firefox")))
              ("s-m"        . magit-status)
              ;; Tabs / workspaces
              ("s-n"        . tab-bar-new-tab)
              ("s-i"        . tab-bar-close-tab)
              ("s-1"        . (lambda () (interactive) (tab-bar-select-tab 1)))
              ("s-2"        . (lambda () (interactive) (tab-bar-select-tab 2)))
              ("s-3"        . (lambda () (interactive) (tab-bar-select-tab 3)))
              ("s-4"        . (lambda () (interactive) (tab-bar-select-tab 4)))
              ("s-5"        . (lambda () (interactive) (tab-bar-select-tab 5)))
              ("s-6"        . (lambda () (interactive) (tab-bar-select-tab 6)))
              ("s-7"        . (lambda () (interactive) (tab-bar-select-tab 7)))
              ;; Sistema
              ("s-<escape>" . ewm-lock-session)
              ("s-<return>" . ewm-toggle-fullscreen)
              ;; Capturas
              ("<Print>"    . (lambda () (interactive)
                                (start-process-shell-command
                                 "screenshot" nil
                                 "grim -g \"$(slurp)\" ~/Imágenes/screenshot-$(date +%Y%m%d-%H%M%S).png")))
              ("S-<Print>"  . (lambda () (interactive)
                                (start-process-shell-command
                                 "screenshot" nil
                                 "grim ~/Imágenes/screenshot-$(date +%Y%m%d-%H%M%S).png")))))

(provide 'user-ewm)
;;; user-ewm.el ends here
