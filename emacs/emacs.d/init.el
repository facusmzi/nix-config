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
(save-place-mode 1)
(show-paren-mode 1)
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
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

(defvar my/disable-line-numbers-modes
  '(pdf-view-mode term-mode shell-mode eshell-mode)
  "Modos donde no quiero `display-line-numbers-mode' activo.")

(defun my/maybe-disable-line-numbers ()
  (when (apply #'derived-mode-p my/disable-line-numbers-modes)
    (display-line-numbers-mode -1)))

(add-hook 'after-change-major-mode-hook #'my/maybe-disable-line-numbers t)



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


(use-package consult-dir
  :config
  (setq consult-dir-sources
        '((:name "Dirs"
		 :narrow ?d
		 :category file
		 :face consult-file
		 :items (lambda ()
			  '("~/nix-config/"
			    "~/Documentos/projects/"
			    "~/Documentos/org/"))))))


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
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode)
  :config
  ;; orderless para completion de lsp
  (defun my/lsp-completion-setup ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))
  (add-hook 'lsp-completion-mode-hook #'my/lsp-completion-setup))



;; ============================================================
;; TREESITTER
;; ============================================================

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        ))


;; ============================================================
;; LSP-MODE
;; ============================================================

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-idle-delay 0.3)
  (lsp-log-io nil)
  (lsp-completion-provider :none)  
  (lsp-headerline-breadcrumb-enable nil)
  :hook
  ((python-ts-mode . lsp-deferred)
   (haskell-mode   . lsp-deferred)
   (nix-mode       . lsp-deferred)   
   (lsp-mode       . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t))





;; ============================================================
;; NIX LSP (nixd)
;; ============================================================

(with-eval-after-load 'lsp-mode
  (setq lsp-nix-nixd-server-path "nixd"
        lsp-nix-nixd-formatting-command ["nixfmt"]
        lsp-nix-nixd-nixpkgs-expr "import <nixpkgs> {}"))



;; ============================================================
;; HASKELL
;; ============================================================

(use-package haskell-mode
  :hook
  (haskell-mode . interactive-haskell-mode))

(use-package lsp-haskell
  :after lsp-mode
  :custom
  (lsp-haskell-server-path "haskell-language-server-wrapper"))





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

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  (pdf-loader-install)
  :custom
  (pdf-view-midnight-colors '("#f8f8f2" . "#282a36")) ;; texto . fondo, paleta Dracula
  :hook
  (pdf-view-mode . pdf-view-midnight-minor-mode))


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
  (evil-move-cursor-back nil)
  (evil-move-beyond-eol t)
  :init
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))



;; ============================================================
;; DIRED (VIM-LIKE)
;; ============================================================

(use-package dired
  :ensure nil
  :after evil
  :config
  (evil-define-key 'normal dired-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file))


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
    "d" 'consult-dir
    "r" 'consult-recent-file
    "l" 'consult-line
    "p" 'consult-ripgrep
    "g" 'magit-status
    "s" 'save-buffer
    "e" 'execute-extended-command
    "q" 'previous-buffer
    "n" 'next-buffer
    "o" 'other-window
    "2" 'split-window-below
    "3" 'split-window-right
    ";" 'comment-line
    )   ))

;; ============================================================
;; RESTAURAR GC
;; ============================================================

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist my/file-name-handler-alist)
