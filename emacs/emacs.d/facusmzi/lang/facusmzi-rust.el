;;; facusmzi-rust --- Rust support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)
(require 'facusmzi-lsp)

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (defhydra facusmzi/ide-rust (:color teal :hint nil)
    "Dispatcher > Rust IDE"
    ("<f12>" keyboard-escape-quit)
    ("S" lsp-workspace-restart "restart lsp")
    ("i" lsp-execute-code-action "code action")
    ("e" flycheck-next-error "goto error")
    ("r" lsp-rename "rename")
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs"))

  (defun facusmzi/rust-setup ()
    "Configuración para programación en Rust."
    (flycheck-mode -1)             ; rustic tiene su propio checker integrado
    (setq-local facusmzi/contextual-ide #'facusmzi/ide-rust/body)
    (setq-local flycheck-check-syntax-automatically '(save mode-enabled)))

  (add-hook 'rustic-mode-hook #'facusmzi/rust-setup))

(provide 'facusmzi-rust)
;;; facusmzi-rust.el ends here
