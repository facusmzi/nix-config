;;; facusmzi-nix --- Nix support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)
(require 'facusmzi-lsp)

;; ─── Rebuild ───────────────────────────────────────────────
(defun facusmzi/nixos-rebuild ()
  "Ejecutar nixos-rebuild switch en un buffer de compilación."
  (interactive)
  (let ((cmd (concat "sudo nixos-rebuild switch --flake ~/nix-config#" (system-name))))
    (switch-to-buffer (compilation-start cmd))
    (rename-buffer "*nixos-rebuild*")))

;; ─── Nix mode ──────────────────────────────────────────────
(use-package nix-mode
  :mode "\\.nix\\'"
  :config
  (defhydra facusmzi/ide-nix (:color teal :hint nil)
    "Dispatcher > Nix IDE"
    ("<f12>" keyboard-escape-quit)
    ("r" facusmzi/nixos-rebuild "rebuild")
    ("S" lsp-workspace-restart "restart lsp")
    ("D" xref-find-definitions "goto def")
    ("R" xref-find-references "goto refs"))

  (defun facusmzi/nix-setup ()
    "Configuración para programación en Nix."
    (setq-local facusmzi/contextual-ide #'facusmzi/ide-nix/body)
    ;; nixd como LSP — está en modules/system/dev/nix.nix
    (lsp-deferred))

  (add-hook 'nix-mode-hook #'facusmzi/nix-setup))

(provide 'facusmzi-nix)
;;; facusmzi-nix.el ends here
