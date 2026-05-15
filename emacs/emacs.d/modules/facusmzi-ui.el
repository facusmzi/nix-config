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

(set-fringe-mode 12)

(global-display-line-numbers-mode 1)
(column-number-mode)
(delete-selection-mode 1)

;; Desactivar números de línea en ciertos modos
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
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
(setq-default line-spacing 0)

;; Tema
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)
  (doom-themes-org-config))

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
