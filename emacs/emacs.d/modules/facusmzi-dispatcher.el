;;; mu-dispatcher.el --- dispatcher -*- lexical-binding: t; -*-

(use-package hydra)

(defhydra mu/dispatcher (:color teal :hint nil)
  "Dispatcher"
  ;; Buffers
  ("o" switch-to-buffer "buffer")
  ("f" find-file "archivo")
  ("r" recentf-open-files "recientes")
  ("k" kill-this-buffer "cerrar")

  ;; Ventanas
  ("\"" evil-window-vsplit "vsplit")
  ("%" evil-window-split "split")
  ("w" delete-window "cerrar ventana")

  ;; Terminal
  ("t" mu/term-here "terminal")

  ;; Utilidades
  ("s" save-buffer "guardar")
  ("q" keyboard-escape-quit "salir"))

(defun mu/open-dispatcher ()
  "Abrir el dispatcher."
  (interactive)
  (let ((hydra-is-helpful t))
    (call-interactively 'mu/dispatcher/body)))

(provide 'facusmzi-dispatcher)
;;; mu-dispatcher.el ends here
