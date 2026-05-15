;;; facusmzi-completion --- autocompletion -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

;; Corfu: completion inline al estilo de othonoi de lcolonq
;; aparece en el punto, sin popups separados
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-quit-no-match t)
  :config
  ;; Cerrar con escape en insert state
  (define-key corfu-map (kbd "<escape>") #'corfu-quit)
  (define-key corfu-map (kbd "C-g")      #'corfu-quit)
  (global-corfu-mode))

;; Cape: backends de completion para corfu
;; (file paths, dabbrev, etc.)
(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(provide 'facusmzi-completion)
;;; facusmzi-completion.el ends here
