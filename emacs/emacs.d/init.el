;;; init.el --- inicialización -*- lexical-binding: t; -*-

;; Startup optimizations
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; Sin backups
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; Cache
(setq user-cache-directory (expand-file-name "~/.cache/emacs/"))
(unless (file-exists-p user-cache-directory)
  (make-directory user-cache-directory t))

;; Historial
(setq history-length 25
      savehist-file (expand-file-name "savehist" user-cache-directory))
(savehist-mode 1)

;; Recentf
(setq recentf-save-file (expand-file-name "recentf" user-cache-directory)
      recentf-max-saved-items 100
      recentf-auto-cleanup 'never)
(recentf-mode 1)

;; Custom file
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; use-package
(require 'package)
(package-initialize)
(require 'use-package)
(setq use-package-always-ensure nil)

;; Load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Módulos
(require 'facusmzi-ui)
(require 'facusmzi-evil)
(require 'facusmzi-editor)
(require 'facusmzi-terminal)
(require 'facusmzi-dispatcher)
(require 'facusmzi-vc)
(require 'facusmzi-lsp)
(require 'facusmzi-lang)
;; Restaurar GC
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)

;; envrc
(use-package envrc
  :config
  (envrc-global-mode))

(provide 'init)
;;; init.el ends here
