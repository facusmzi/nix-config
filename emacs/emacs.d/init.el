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

;; Desactivar números de línea en ciertos modos
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Sin backups
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

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

;; Directorios cache (ideal para Nix)
(setq user-cache-directory
      (expand-file-name "~/.cache/emacs/"))

(unless (file-exists-p user-cache-directory)
  (make-directory user-cache-directory t))

;; Historial
(setq history-length 25)

(setq savehist-file
      (expand-file-name "savehist" user-cache-directory))

(savehist-mode 1)

;; Recentf
(setq recentf-save-file
      (expand-file-name "recentf" user-cache-directory))

(setq recentf-max-saved-items 100)
(setq recentf-auto-cleanup 'never)

(recentf-mode 1)

;; use-package
(require 'package)
(package-initialize)

(require 'use-package)

(setq use-package-always-ensure nil) ;; Nix instala paquetes

;; Tema
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  (load-theme 'doom-dracula t)
  (doom-themes-org-config))

;; Custom file
(setq custom-file
      (locate-user-emacs-file "custom-vars.el"))

(load custom-file 'noerror 'nomessage)

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

;; Ligatures lindas
(global-prettify-symbols-mode 1)

;; envrc
(use-package envrc
  :config
  (envrc-global-mode))
