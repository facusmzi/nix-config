;;; mu-ui.el --- interfaz -*- lexical-binding: t; -*-

;; UI básica
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Transparencia del frame
(let ((opacity 100))
  (set-frame-parameter nil 'alpha-background opacity)
  (add-to-list 'default-frame-alist `(alpha-background . ,opacity)))

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)

;; Cursor solo visible en ventana activa
(setq cursor-in-non-selected-windows nil)

;; Sin parpadeo visual del cursor
(setq visible-cursor nil)

;; Performance visual
(setq-default bidi-display-reordering nil)

;; Fringe
(set-fringe-mode 12)

;; Separación entre líneas
(setq-default line-spacing 2)

(global-display-line-numbers-mode 1)
(column-number-mode)
(delete-selection-mode 1)

;; Desactivar números de línea en ciertos modos
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                eat-mode-hook
                pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Fuente
(set-face-attribute 'default nil
                    :font "FiraCode Nerd Font"
                    :height 130
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil
                    :font "Roboto"
                    :height 130
                    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
                    :font "FiraCode Nerd Font"
                    :height 130
                    :weight 'medium)

(set-language-environment "UTF-8")

;; Tema
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)
  (doom-themes-org-config)

  ;; Colores doom-dracula
  ;; bg-main = "#282a36"
  ;; bg-alt  = "#21222c"
  (let ((bg-main "#282a36")
        (bg-alt  "#21222c"))
    (set-face-attribute 'vertical-border nil
                        :foreground bg-alt
                        :background bg-alt)
    (set-face-attribute 'fringe nil
                        :foreground bg-alt
                        :background bg-alt)))

;; Icons
(use-package nerd-icons)

;; Doom modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  (display-battery-mode 1)
  (setq display-time-default-load-average nil
        display-time-24hr-format t
        display-time-day-and-date t)
  (display-time-mode 1)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-minor-modes nil))

;; Dired con iconos
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; Ligatures
(global-prettify-symbols-mode 1)

(provide 'facusmzi-ui)
;;; mu-ui.el ends here
