;; Pantalla completa
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; UI básica
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 12)
(global-display-line-numbers-mode 1)
(column-number-mode)
(delete-selection-mode 1)

;; Sin backups
(setq make-backup-files nil
      auto-save-default nil)

;; Fuente
(set-frame-font "Iosevka Comfy:pixelsize=20")
(set-face-attribute 'line-number nil :height 1.2)

;; Historial
(recentf-mode 1)
(global-set-key (kbd "C-c r") 'recentf-open-files)
(setq savehist-file "~/.local/share/emacs/history")
(savehist-mode 1)

;; Desactivar line-numbers en terminales
(dolist (mode '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; use-package
(require 'use-package)
(setq use-package-always-ensure nil)

;; Tema
(load-theme 'ef-duo-dark t)

;; Custom file
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  (display-battery-mode 1)
  (display-time-mode 1)
  ;; Ocultar porcentaje/posición
  (setq mode-line-percent-position nil)
  :custom
  (doom-modeline-height 15))
