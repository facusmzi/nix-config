;;; facusmzi-theme --- UI theme -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

;; ─── UI básica ─────────────────────────────────────────────
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 12)

(global-display-line-numbers-mode 1)
(dolist (mode '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ─── Fuentes ───────────────────────────────────────────────
;; Igual que lcolonq: set-frame-font Y set-face-font para asegurarse
;; que aplica tanto al frame actual como a frames futuros
(set-frame-font "Iosevka Comfy:pixelsize=20")
(set-face-font 'default "Iosevka Comfy:pixelsize=20")
(set-face-attribute 'line-number nil :height 1.2)

;; Fuente para emojis — sin esto los emojis aparecen como cajitas
(set-fontset-font
 t 'symbol
 (font-spec
  :family "Noto Color Emoji"
  :size 18
  :weight 'normal
  :width 'normal
  :slant 'normal))

;; ─── Tema ──────────────────────────────────────────────────
(use-package ef-themes
  :config
  (ef-themes-select 'ef-duo-dark)

  ;; ef-themes-with-colors nos da acceso a las variables de color del tema
  ;; para usarlas en otras faces — así todo queda consistente
  (ef-themes-with-colors
    ;; Hacer que el borde entre ventanas y el fringe se mezclen con el fondo
    (set-face-attribute 'vertical-border nil
                        :foreground bg-alt
                        :background bg-alt)
    (set-face-attribute 'fringe nil
                        :foreground bg-alt
                        :background bg-alt)))

;; ─── Outshine ──────────────────────────────────────────────
;; Mejora outline-minor-mode con folding y navegación
;; lcolonq lo usa en colonq-theme, lo seguimos
(use-package outshine
  :config
  (add-hook 'outline-minor-mode-hook 'outshine-mode))

(provide 'facusmzi-theme)
;;; facusmzi-theme.el ends here
