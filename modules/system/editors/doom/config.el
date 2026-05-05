;;; config.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")

(after! haskell-mode
  (setq haskell-stylish-on-save nil))


(after! org-roam
  (setq org-roam-directory "~/org/roam/")
  (setq org-roam-dailies-directory "daily/"))


(after! eglot
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd"))))
