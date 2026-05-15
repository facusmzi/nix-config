;;; facusmzi-elisp --- Emacs Lisp support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)
(require 'facusmzi-lsp)

(defhydra facusmzi/ide-elisp (:color teal :hint nil)
  "Dispatcher > ELisp IDE"
  ("<f12>" keyboard-escape-quit)
  ("e" eval-defun "eval defun")
  ("i" eval-buffer "eval buffer")
  ("r" ielm "repl"))

(defun facusmzi/elisp-setup ()
  "Configuración para programación en Emacs Lisp."
  (outline-minor-mode)
  (setq-local facusmzi/contextual-ide #'facusmzi/ide-elisp/body)
  ;; K muestra ayuda con apropos en elisp
  (setq-local facusmzi/contextual-lookup #'selector-apropos))

(add-hook 'emacs-lisp-mode-hook #'facusmzi/elisp-setup)
(add-hook 'ielm-mode-hook #'facusmzi/elisp-setup)

(provide 'facusmzi-elisp)
;;; facusmzi-elisp.el ends here
