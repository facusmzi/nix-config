;;; facusmzi-theme --- UI theme -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 12)

(global-display-line-numbers-mode 1)
(dolist (mode '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-frame-font "Iosevka Comfy:pixelsize=20")
(set-face-attribute 'line-number nil :height 1.2)

(use-package ef-themes
  :config
  (load-theme 'ef-duo-dark t))

(provide 'facusmzi-theme)
;;; facusmzi-theme.el ends here
