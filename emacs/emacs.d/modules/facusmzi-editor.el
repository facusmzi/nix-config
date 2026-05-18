;;; mu-editor.el --- editor -*- lexical-binding: t; -*-

;; Mejor scrolling
(setq scroll-step 1
      scroll-conservatively 10000
      scroll-margin 5)

;; Parentesis
(show-paren-mode 1)
(electric-pair-mode 1)

;; Indentacion
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Direnv integration
(use-package envrc
  :config
  (envrc-global-mode))

;; Resaltado de la linea actual
(global-hl-line-mode 1)

;; Which-key para descubrir keybindings
(use-package which-key
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.5))


(use-package outshine
  :config
  (add-hook 'outline-minor-mode-hook #'outshine-mode))

(provide 'facusmzi-editor)
;;; mu-editor.el ends here
