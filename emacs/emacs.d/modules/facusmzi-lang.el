;;; facusmzi-lang.el --- soporte de lenguajes -*- lexical-binding: t; -*-

;; Variable contextual
(defvar-local mu/contextual-ide nil)

;; Sin prompt al buscar definiciones
(setq-default xref-prompt-for-identifier nil)

;; Función wrapper que abre el IDE contextual o el genérico
(defun mu/open-ide ()
  "Abrir IDE contextual o genérico si no hay uno definido."
  (interactive)
  (if mu/contextual-ide
      (funcall mu/contextual-ide)
    (mu/ide-generic/body)))

;; ─── IDE genérico (fallback para cualquier modo con LSP) ────
(defhydra mu/ide-generic (:color teal :hint nil)
  "IDE"
  ("<f12>" keyboard-escape-quit)
  ("D" xref-find-definitions "goto def")
  ("R" xref-find-references "goto refs")
  ("r" lsp-rename "renombrar")
  ("i" lsp-execute-code-action "acción")
  ("e" flycheck-next-error "goto error")
  ("S" lsp-workspace-restart "restart LSP"))

;; ─── Rust ───────────────────────────────────────────────────
(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (defhydra mu/ide-rust (:color teal :hint nil)
    "IDE › Rust"
    ("<f12>" keyboard-escape-quit)
    ("S" lsp-workspace-restart "restart")
    ("i" lsp-execute-code-action "acción")
    ("r" lsp-rename "renombrar")
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs")
    ("e" flycheck-next-error "goto error")
    ("d" mu/dap-dispatcher/body "debug"))
  (defun mu/rust-setup ()
    (lsp)
    (setq-local mu/contextual-ide #'mu/ide-rust/body)
    (setq-local lsp-eldoc-hook nil))
  (add-hook 'rustic-mode-hook #'mu/rust-setup))

;; ─── C / C++ ────────────────────────────────────────────────
(defhydra mu/ide-c (:color teal :hint nil)
  "IDE › C/C++"
  ("<f12>" keyboard-escape-quit)
  ("i" (compile "make") "build")
  ("D" xref-find-definitions "goto def")
  ("R" xref-find-references "goto refs")
  ("e" flycheck-next-error "goto error")
  ("d" mu/dap-dispatcher/body "debug"))

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
    "IDE › Nix"
    ("<f12>" keyboard-escape-quit)
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs"))
  (defun mu/nix-setup ()
    (lsp)
    (setq-local mu/contextual-ide #'mu/ide-nix/body))
  (add-hook 'nix-mode-hook #'mu/nix-setup))

(provide 'facusmzi-lang)
;;; facusmzi-lang.el ends here
