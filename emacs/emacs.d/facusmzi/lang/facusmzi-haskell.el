;;; facusmzi-haskell --- Haskell support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)
(require 'facusmzi-lsp)

(use-package lsp-haskell
  :config
  ;; Ignorar directorios de build en el file watcher — sin esto lsp se vuelve lento
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]\\dist-newstyle$" t)
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]\\deps$" t)

  (defhydra facusmzi/ide-haskell (:color teal :hint nil)
    "Dispatcher > Haskell IDE"
    ("<f12>" keyboard-escape-quit)
    ("S" lsp-workspace-restart "restart lsp")
    ("i" lsp-execute-code-action "code action")
    ("e" flycheck-next-error "goto error")
    ("r" lsp-rename "rename")
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs")
    ("I" haskell-navigate-imports "goto imports")
    ("C" haskell-cabal-visit-file "goto cabal"))

  (defun facusmzi/haskell-setup ()
    "Configuración para programación en Haskell."
    (setq-local xref-prompt-for-identifier nil)
    (setq-local facusmzi/contextual-ide #'facusmzi/ide-haskell/body)
    (setq-local flycheck-check-syntax-automatically '(save mode-enabled))
    (lsp-deferred))

  (add-hook 'haskell-mode-hook #'facusmzi/haskell-setup))

(provide 'facusmzi-haskell)
;;; facusmzi-haskell.el ends here
