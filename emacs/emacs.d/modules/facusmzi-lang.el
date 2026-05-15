;;; facusmzi-lang.el --- soporte de lenguajes -*- lexical-binding: t; -*-

;; Variable contextual como lcolonq
(defvar-local mu/contextual-ide
    (lambda () (interactive) (message "No hay IDE en este modo")))

;; ─── Rust ───────────────────────────────────────────────────
(use-package rust-mode
  :config
  (defhydra mu/ide-rust (:color teal :hint nil)
    "IDE > Rust"
    ("<f12>" keyboard-escape-quit)
    ("S" lsp-workspace-restart "restart")
    ("i" lsp-execute-code-action "accion")
    ("r" lsp-rename "renombrar")
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs")
    ("e" flycheck-next-error "goto error"))
  (defun mu/rust-setup ()
    (lsp)
    (setq-local mu/contextual-ide #'mu/ide-rust/body)
    (setq-local lsp-eldoc-hook nil))
  (add-hook 'rust-mode-hook #'mu/rust-setup))

;; ─── C / C++ ────────────────────────────────────────────────
(defhydra mu/ide-c (:color teal :hint nil)
  "IDE > C/C++"
  ("<f12>" keyboard-escape-quit)
  ("i" (compile "make") "build")
  ("D" xref-find-definitions "goto def")
  ("R" xref-find-references "goto refs")
  ("e" flycheck-next-error "goto error"))

(defun mu/c-setup ()
  (lsp)
  (setq-local mu/contextual-ide #'mu/ide-c/body)
  (setq-local lsp-eldoc-hook nil)
  (setq-local tab-width 4)
  (setq-local c-basic-offset 4))

(add-hook 'c-mode-hook #'mu/c-setup)
(add-hook 'c++-mode-hook #'mu/c-setup)

;; ─── Nix ────────────────────────────────────────────────────
(use-package nix-mode
  :mode "\\.nix\\'"
  :config
  (defhydra mu/ide-nix (:color teal :hint nil)
    "IDE > Nix"
    ("<f12>" keyboard-escape-quit)
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs"))
  (defun mu/nix-setup ()
    (lsp)
    (setq-local mu/contextual-ide #'mu/ide-nix/body)
    (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection '("nixd"))
      :major-modes '(nix-mode)
      :server-id 'nixd)))
  (add-hook 'nix-mode-hook #'mu/nix-setup))

(provide 'facusmzi-lang)
;;; facusmzi-lang.el ends here
