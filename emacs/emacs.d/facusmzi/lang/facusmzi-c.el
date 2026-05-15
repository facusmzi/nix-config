;;; facusmzi-c --- C/C++ support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)
(require 'facusmzi-lsp)

(defhydra facusmzi/ide-c (:color teal :hint nil)
  "Dispatcher > C/C++ IDE"
  ("<f12>" keyboard-escape-quit)
  ("S" lsp-workspace-restart "restart lsp")
  ("i" lsp-execute-code-action "code action")
  ("b" (compile "make") "build")
  ("e" flycheck-next-error "goto error")
  ("r" lsp-rename "rename")
  ("D" xref-find-definitions "goto def")
  ("R" xref-find-references "goto refs"))

(defun facusmzi/c-setup ()
  "Configuración para programación en C/C++."
  (c-set-style "linux")
  (hl-line-mode)
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local c-basic-offset 4)
  (setq-local facusmzi/contextual-ide #'facusmzi/ide-c/body)
  ;; clangd via lsp — está en modules/system/dev/cpp.nix
  (lsp-deferred))

(add-hook 'c-mode-hook   #'facusmzi/c-setup)
(add-hook 'c++-mode-hook #'facusmzi/c-setup)

(provide 'facusmzi-c)
;;; facusmzi-c.el ends here
