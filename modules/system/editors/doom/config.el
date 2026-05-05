;;; config.el -*- lexical-binding: t; -*-

;; Lee nombre y email desde las variables de entorno que sops
;; ya inyecta en bash (GIT_AUTHOR_NAME / GIT_AUTHOR_EMAIL)
(setq user-full-name (or (getenv "GIT_AUTHOR_NAME") "")
      user-mail-address (or (getenv "GIT_AUTHOR_EMAIL") ""))



;; (setq doom-font (font-spec :family "Terminess Nerd Font" :weight 'medium)
;;       doom-variable-pitch-font (font-spec :family "Terminess Nerd Font"))

(setq doom-theme 'catppuccin
      catppuccin-flavor 'mocha) ; or 'frappe 'latte, 'macchiato, or 'mocha


;; set transparency... I don't think this works so TODO
;;(set-frame-parameter (selected-frame) 'alpha '(85 85))
;;(add-to-list 'default-frame-alist '(alpha 85 85))

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(after! haskell-mode
  (setq haskell-stylish-on-save nil))

(after! org-roam
  (setq org-roam-directory "~/org/roam/")
  (setq org-roam-dailies-directory "daily/"))

(after! org-agenda
  (setq org-agenda-span 'month))

(after! elfeed
  (setq elfeed-search-filter "@12-month-ago"))

(after! eglot
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd"))))

(after! flycheck
  (setq flycheck-idle-change-delay 0.1))

(use-package! dape)


