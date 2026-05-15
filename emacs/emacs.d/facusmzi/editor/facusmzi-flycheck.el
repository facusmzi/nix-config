;;; facusmzi-flycheck --- program analysis -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(use-package flycheck
  :custom
  ;; No mostrar errores en una ventana separada — silencioso por defecto
  (flycheck-display-errors-function (lambda (errors) (ignore errors) nil))
  (flycheck-display-errors-delay 0.1)
  ;; Heredar el load-path de Emacs para el checker de elisp
  (flycheck-emacs-lisp-load-path 'inherit)
  ;; Solo chequear al guardar o al activar el modo
  (flycheck-check-syntax-automatically '(save mode-enabled))
  :config
  ;; Limpiar el keymap — no queremos sus bindings
  (setf (cdr flycheck-mode-map) nil)
  (global-flycheck-mode))

;; ─── Eldoc ─────────────────────────────────────────────────
(use-package eldoc
  :custom
  (eldoc-idle-delay 0.1)
  (eldoc-echo-area-prefer-doc-buffer t)
  :config
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose)
  (setq eldoc-display-functions '(eldoc-display-in-echo-area eldoc-display-in-buffer)))

(provide 'facusmzi-flycheck)
;;; facusmzi-flycheck.el ends here
