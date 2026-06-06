;;; init.el -*- lexical-binding: t; -*-

;; ============================================================
;; STARTUP
;; ============================================================

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)


;; ============================================================
;; INTERFAZ MÍNIMA
;; ============================================================

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(tooltip-mode -1)
(setq-default cursor-in-non-selected-windows nil
              bidi-display-reordering nil)
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      sentence-end-double-space nil
      custom-file "/dev/null"
      confirm-kill-emacs 'y-or-n-p)


;; ============================================================
;; COMPORTAMIENTO DEL EDITOR
;; ============================================================

(electric-pair-mode 1)
(global-auto-revert-mode 1)
(setq use-short-answers t)
(delete-selection-mode 1)
(setq scroll-step 1)


;; ============================================================
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

(global-display-line-numbers-mode 1)
(column-number-mode 1)


;; ============================================================
;; HISTORIAL Y ARCHIVOS RECIENTES
;; ============================================================

(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items nil)


;; ============================================================
;; BACKUPS
;; ============================================================

(setq make-backup-files nil
      auto-save-default nil)
(setq create-lockfiles nil)

;; ;; ============================================================
;; ;; TEMA
;; ;; ============================================================

(use-package dracula-theme
  :config
  (load-theme 'dracula t))


;; ;; ============================================================
;; ;; WHICH-KEY
;; ;; ============================================================

(use-package which-key
  :config
  (which-key-mode))




;; ============================================================
;; COMPLETION
;; ============================================================

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

(use-package consult)



;; ============================================================
;; MAGIT
;; ============================================================

(use-package magit)




;; ;; ============================================================
;; ;; ENVRC
;; ;; ============================================================

(use-package envrc
  :init
  (envrc-global-mode))



;; ;; ============================================================
;; ;; NIX-MODE
;; ;; ============================================================

(use-package nix-mode
  :mode "\\.nix\\'")





;; ============================================================
;; CORFU
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  :init
  (global-corfu-mode))


;; ============================================================
;; TREESITTER
;; ============================================================

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        ))


;; ============================================================
;; EGLOT (LSP)
;; ============================================================
(use-package eglot
  :hook
  ((python-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("pyright-langserver" "--stdio"))))




;; ============================================================
;; ORG-BABEL CSHARP
;; ============================================================

(let* ((dotnet-bin
        (string-trim
         (shell-command-to-string "readlink -f $(which dotnet)")))
       (dotnet-root
        (directory-file-name
         (file-name-directory dotnet-bin))))
  (setenv "DOTNET_ROOT" dotnet-root))


(load (expand-file-name "ob-csharp" user-emacs-directory))

(use-package org
  :config
  (setq org-babel-csharp-default-target-framework "net10.0")

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((csharp . t)))

  (setq org-confirm-babel-evaluate nil)

  ;; ============================================================
  ;; LaTeX previews (FIX dvipng → dvisvgm)
  ;; ============================================================
  (setq org-startup-with-latex-preview t)
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-latex-create-formula-image-program 'dvisvgm))



;; ============================================================
;; GPTEL + COPILOT
;; ============================================================

(use-package gptel
  :config
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))
  (setq gptel-model 'gpt-4o))




;; ============================================================
;; EVIL MODE
;; ============================================================

(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil) ;; requerido para evil-collection
  (evil-undo-system 'undo-redo) ;; usa el undo nativo de emacs 28+
  :init
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))


;; ============================================================
;; GENERAL (LEADER KEY)
;; ============================================================

(use-package general
  :config
  (general-create-definer my/leader
    :states '(normal visual)
    :keymaps 'override
    :prefix "q")

  (my/leader
    "w" 'delete-window
    "k" 'kill-current-buffer
    "f" 'find-file
    "b" 'consult-buffer
    "r" 'consult-recent-file
    "g" 'magit-status
    "s" 'save-buffer
    "q" 'previous-buffer
    "2" 'split-window-below
    "3" 'split-window-right))

;; ============================================================
;; RESTAURAR GC
;; ============================================================

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist my/file-name-handler-alist)
