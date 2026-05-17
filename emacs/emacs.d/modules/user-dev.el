;;; user-dev.el --- Herramientas de desarrollo -*- lexical-binding: t -*-

;; envrc aplica las variables de direnv por buffer, no globalmente.
;; Clave cuando hay varios proyectos con distintos flakes abiertos.
;; Tiene que ir antes de eglot y dap para que vean los binarios del devshell.
(use-package envrc
  :init (envrc-global-mode 1))

;;; LSP (Eglot)
(use-package eglot
  :hook
  ;; Corre después de que envrc cargó el entorno
  (hack-local-variables . eglot-ensure)

  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-confirm-server-initiated-edits nil)

  :config
  ;; rust-analyzer: insertar paréntesis al completar funciones.
  ;; Requiere yasnippet activo para expandir el snippet que manda el LSP.
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:completion
                   (:callable
                    (:snippets "add_parentheses")))))

  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("M-."     . xref-find-definitions)
              ("M-?"     . xref-find-references)
              ("M-,"     . xref-go-back)))

;; Muestra en qué función/struct/módulo estás en el header del buffer.
(use-package breadcrumb
  :hook (eglot-managed-mode . breadcrumb-local-mode))

;; Requerido por eglot para expandir snippets que manda el LSP.
;; Sin esto, completar funciones no agrega paréntesis aunque rust-analyzer
;; los envíe. Yasnippet actúa solo como expansor para el LSP; tempel se
;; encarga de los snippets propios.
(use-package yasnippet
  :init (yas-global-mode 1))

;;; Completion inline (Corfu)
(use-package corfu
  :init (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match t))

(use-package cape
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-file)
              (add-to-list 'completion-at-point-functions #'cape-keyword))))

;;; Snippets (Tempel)
;; Integrado con completion-at-point → funciona con Corfu.
;; tempel-collection agrega snippets predefinidos para Rust, C++, org, etc.
(use-package tempel
  :bind (("M-+" . tempel-insert)
         ("M-*" . tempel-complete))
  :hook (prog-mode . tempel-abbrev-mode))

(use-package tempel-collection
  :after tempel)

;;; Debug (DAP)
;; Usa lldb-dap como adaptador, incluido en el devshell de C++.
;; envrc se encarga de que Emacs vea el binario correcto por proyecto.
(use-package dap-mode
  :after eglot
  :config
  (dap-auto-configure-mode 1)
  (require 'dap-lldb)

  (setq dap-lldb-debug-program
        (list (or (executable-find "lldb-dap")
                  (executable-find "lldb-vscode")
                  "lldb-dap")))

  (dap-register-debug-template
   "C++ LLDB"
   (list :type "lldb"
         :request "launch"
         :name "C++ LLDB"
         :program "${workspaceFolder}/build/${fileBasenameNoExtension}"
         :cwd "${workspaceFolder}"
         :args []
         :stopOnEntry nil))

  :bind (:map dap-mode-map
              ("C-c d d" . dap-debug)
              ("C-c d b" . dap-breakpoint-toggle)
              ("C-c d c" . dap-continue)
              ("C-c d n" . dap-next)
              ("C-c d i" . dap-step-in)
              ("C-c d o" . dap-step-out)
              ("C-c d q" . dap-disconnect)
              ("C-c d r" . dap-debug-restart)
              ("C-c d e" . dap-eval-thing-at-point)))

;;; Rust (Rustic)
;; Wrapper sobre rust-mode con integración nativa a cargo y soporte para eglot.
;; rust-analyzer tiene que estar en el PATH del devshell — envrc se encarga.
(use-package rustic
  :custom
  (rustic-lsp-client 'eglot)
  (rustic-format-on-save t)

  :config
  ;; eglot-managed-mode-hook garantiza que la conexión LSP está activa
  ;; antes de habilitar inlay hints.
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when (and (derived-mode-p 'rustic-mode)
                         (fboundp 'eglot-inlay-hints-mode))
                (eglot-inlay-hints-mode 1))))

  :bind (:map rustic-mode-map
              ("C-c c r" . rustic-cargo-run)
              ("C-c c b" . rustic-cargo-build)
              ("C-c c t" . rustic-cargo-test)
              ("C-c c c" . rustic-cargo-clippy)
              ("C-c c f" . rustic-cargo-fmt)
              ("C-c c a" . rustic-cargo-add)
              ("C-c c e" . rustic-cargo-expand)
              ("C-c c d" . eldoc-doc-buffer)))

(provide 'user-dev)
;;; user-dev.el ends here
