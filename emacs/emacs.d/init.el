;;; init.el -*- lexical-binding: t; -*-
;; interfaz mínima
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default cursor-in-non-selected-windows nil)

;; líneas y columna
(global-display-line-numbers-mode 1)
;; (column-number-mode 1)
(setq inhibit-startup-message t)

;; tema
(load-theme 'dracula t)

(use-package which-key
  :config
  (which-key-mode))

;; backups en una carpeta
(setq make-backup-files nil)
(setq auto-save-default nil)

;; saca la confirmacion de cerrar buffer
;;(setq confirm-kill-processes nil)

;; recargar archivos cambiados afuera de emacs
(global-auto-revert-mode 1)

;; parenthesis matching
(show-paren-mode 1)

;; y/n en vez de yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;;;;;;;; basic

;; ----------------------------
;; completion moderno
;; ----------------------------

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-f" . find-file)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(savehist-mode 1)
(recentf-mode 1)



