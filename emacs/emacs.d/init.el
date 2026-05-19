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
  :ensure t
  :config
  (which-key-mode))

;; backups en una carpeta
(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups")))

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
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-x C-f" . find-file)))

(use-package rainbow-delimiters
  :ensure t
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
  :ensure t
  :config
  ;; abrir vterm siempre en insert mode
  (add-hook 'vterm-mode-hook #'evil-insert-state))

;; ----------------------------
;; keybinds
;; ----------------------------

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package general
  :ensure t
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

(use-package magit
  :ensure t)

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-cycle t))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))


(use-package envrc
  :ensure t
  :config
  (envrc-global-mode))




;; ----------------------------
;; LSP - soporte de lenguajes
;; ----------------------------

(use-package lsp-mode
  :ensure t

  :init
  (setq lsp-keymap-prefix "C-c l")

  :custom
  (lsp-lens-enable nil)
  (lsp-eldoc-render-all nil)
  (lsp-completion-provider :capf)
  (read-process-output-max (* 1024 1024))

  :hook
  ((typescript-mode . lsp-deferred)
   (js2-mode . lsp-deferred)
   (web-mode . lsp-deferred))

  :commands
  (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :after lsp-mode

  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.5)
  (lsp-ui-sideline-enable nil))

;; ----------------------------
;; modos web
;; ----------------------------

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"

  :hook
  (js2-mode . lsp-deferred))

(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"

  :hook
  (typescript-mode . lsp-deferred))

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'"
         "\\.php\\'"
         "\\.tsx\\'"
         "\\.jsx\\'")

  :hook
  (web-mode . lsp-deferred))


(use-package json-mode
  :ensure t
  :mode "\\.json\\'"

  :hook
  (json-mode . (lambda ())))

;; ----------------------------
;; snippets
;; ----------------------------

(use-package yasnippet
  :ensure t

  :config
  (yas-global-mode 1))
