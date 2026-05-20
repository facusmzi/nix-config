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


(defun my/kill-buffer-force ()
  (interactive)
  (let ((kill-buffer-query-functions nil)
        (confirm-kill-processes nil))
    (kill-current-buffer)))
;; ----------------------------
;; terminal
;; ----------------------------

(use-package vterm
  :config
  (add-hook 'vterm-mode-hook #'evil-insert-state)

  (add-hook 'vterm-mode-hook
            (lambda ()
              (evil-local-set-key 'normal (kbd "M-h") 'windmove-left)
              (evil-local-set-key 'normal (kbd "M-j") 'windmove-down)
              (evil-local-set-key 'normal (kbd "M-k") 'windmove-up)
              (evil-local-set-key 'normal (kbd "M-l") 'windmove-right))))



;; ----------------------------
;; keybinds
;; ----------------------------

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)

  (define-key evil-motion-state-map
    (kbd "0")
    #'evil-first-non-blank))

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
  ;; archivos
  "f" '(my/find-file-or-create-directory :which-key "find file")

  ;; abrir archivos recientes
  "r" '(consult-recent-file :which-key "recent files")

  ;; buffers
  "b" '(consult-buffer :which-key "buffers")

  ;; guardar
  "s" '(save-buffer :which-key "save buffer")

  ;; git
  "g" '(magit-status :which-key "magit")

  ;; terminal
  "t" '(vterm :which-key "terminal")

  ;; último buffer
  "q" '(mode-line-other-buffer :which-key "last buffer")

  ;; kill buffer
  "k" '(my/kill-buffer-force :which-key "kill buffer")
  ;; cierra una ventana
  "w" '(delete-window :which-key "close window")
  ;; buscar dentro del archivo
  "/" '(consult-line :which-key "search")


  ;; ----------------------------
  ;; splits
  ;; ----------------------------


  "|" '(split-window-right :which-key "vertical split")
  "-" '(split-window-below :which-key "horizontal split") 

  ;; ----------------------------
  ;; lsp / ide
  ;; ----------------------------

  "i" '(:ignore t :which-key "lsp")

  ;; ir a definición
  "id" '(lsp-find-definition :which-key "definition")

  ;; documentación
  "ih" '(lsp-describe-thing-at-point :which-key "hover docs")
  
  ;; formatting
  "if" '(lsp-format-buffer :which-key "format")

  ;; errores
  "ie" '(flycheck-list-errors :which-key "errors")

  ;; restart lsp
  "iR" '(lsp-restart-workspace :which-key "restart lsp")))


;; ----------------------------
;; navegacion de venatanas
;; ----------------------------

  (global-set-key (kbd "M-h") 'windmove-left)
  (global-set-key (kbd "M-j") 'windmove-down)
  (global-set-key (kbd "M-k") 'windmove-up)
  (global-set-key (kbd "M-l") 'windmove-right)
 

;; ----------------------------
;; programación
;; ----------------------------

(use-package magit)

(use-package corfu
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 1))


(add-hook 'lsp-completion-mode-hook
          (lambda ()
            (setq-local completion-styles '(orderless basic))
            (setq-local completion-category-defaults nil)))

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
  :custom
  (lsp-lens-enable nil)
  (lsp-eldoc-render-all nil)
  (lsp-completion-provider :capf)

  (lsp-csharp-server-path (executable-find "OmniSharp"))
  
  :commands
  (lsp lsp-deferred))



(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.5)
  (lsp-ui-sideline-enable nil)

  :config
  (add-to-list
   'display-buffer-alist
   '("\\*lsp-help\\*"
     (display-buffer-same-window))))

(use-package flycheck
  :init
  (global-flycheck-mode)

  :custom
  (flycheck-indication-mode nil)
  (flycheck-display-errors-delay 0.1)
  (flycheck-check-syntax-automatically '(save mode-enabled))

  :config
  (setq flycheck-emacs-lisp-load-path 'inherit))


;;; csharp

(use-package csharp-mode
  :mode "\\.cs\\'")

(add-hook 'csharp-mode-hook #'lsp)
;; -----------------------------
;; nix
;; -----------------------------


(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))


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


(electric-pair-mode 1)




;; ----------------------------
;; peticiones http
;; ----------------------------
(use-package restclient
  :mode ("\\.http\\'" . restclient-mode))

(provide 'init)
;;; init.el ends here
