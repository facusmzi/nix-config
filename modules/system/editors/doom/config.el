;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")


(setq doom-font (font-spec :family "Terminess Nerd Font" :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Terminess Nerd Font"))

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


(after! spell
  (setq ispell-program-name "hunspell")
  ;; Cambia esto a tu idioma principal:
  (setq ispell-dictionary "es_ES")

  (setq ispell-hunspell-dict-paths-alist
        '(("es_ES" "/run/current-system/sw/share/hunspell/es_ES.aff")
          ("en_US" "/run/current-system/sw/share/hunspell/en_US.aff")))

  ;; Línea de seguridad extra:
  (setenv "DICPATH" "/run/current-system/sw/share/hunspell"))
