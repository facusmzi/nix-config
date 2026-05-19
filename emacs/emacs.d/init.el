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
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-x C-f" . find-file)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(savehist-mode 1)
(recentf-mode 1)

;; ----------------------------
;; funciones custom
;; ----------------------------

(defun my/find-file-or-create-directory (path)
  "Open file or create directory if PATH ends with /."
  (interactive "FFind file: ")

  (if (string-suffix-p "/" path)
      (progn
        (make-directory path t)
        (dired path))
    (find-file path)))

;; ----------------------------
;; terminal
;; ----------------------------

(use-package vterm
  :config
  ;; abrir vterm siempre en insert mode
  (add-hook 'vterm-mode-hook #'evil-insert-state))

;; ----------------------------
;; keybinds
;; ----------------------------

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config

  (setq general-auto-unbind-keys t)

  (general-create-definer my/leader-keys
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "q"
    :global-prefix "C-q")

  (my/leader-keys
    "f" '(my/find-file-or-create-directory :which-key "find file")
    "b" '(consult-buffer :which-key "buffers")
    "s" '(save-buffer :which-key "save buffer")
    "g" '(magit-status :which-key "magit")
    "t" '(vterm :which-key "terminal")
    "q" '(mode-line-other-buffer :which-key "last buffer")))

;; ----------------------------
;; programación
;; ----------------------------

(use-package magit)

(use-package corfu
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-cycle t))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))


(use-package envrc
  :config
  (envrc-global-mode))




;; ----------------------------
;; LSP - soporte de lenguajes
;; ----------------------------

(setq read-process-output-max (* 1024 1024))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-lens-enable nil)
  (lsp-eldoc-render-all nil)
  (lsp-completion-provider :capf)
  :commands
  (lsp lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.5)
  (lsp-ui-sideline-enable nil))

;; ----------------------------
;; modos web
;; ----------------------------

(use-package web-mode
  :mode ("\\.html\\'")
  :hook
  (web-mode . lsp-deferred))

(use-package json-mode
  :mode "\\.json\\'")

;; tree-sitter built-in (emacs 30)
(defun my/typescript-setup ()
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  (lsp-deferred))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))

(add-hook 'typescript-ts-mode-hook #'my/typescript-setup)
(add-hook 'tsx-ts-mode-hook #'my/typescript-setup)
(add-hook 'js-ts-mode-hook #'my/typescript-setup)
(add-hook 'html-mode-hook #'lsp-deferred)

;; ----------------------------
;; snippets
;; ----------------------------

(use-package yasnippet
  :config
  (yas-global-mode 1))
