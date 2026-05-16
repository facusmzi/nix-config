;;; mu-dispatcher.el --- dispatcher -*- lexical-binding: t; -*-

(use-package hydra)

(defhydra mu/dispatcher (:color teal :hint nil)
  "Dispatcher"
  ;; Buffers
  ("o" consult-buffer "buffer")
  ("f" find-file "archivo")
  ("r" consult-recent-file "recientes")
  ("k" (let ((kill-buffer-query-functions '(buffer-modified-p)))
         (kill-buffer (current-buffer))) "cerrar")
  ;; Proyectos
  ("p" projectile-switch-project "proyecto")
  ("F" projectile-find-file "archivo en proyecto")
  ("/" consult-ripgrep "buscar")
  ;; Ventanas
  ("\"" (progn (evil-window-vsplit) (windmove-right)) "vsplit")
  ("%" (progn (evil-window-split) (windmove-down)) "split")
  ("w" delete-window "cerrar ventana")
  ;; Terminal
  ("t" mu/term-here "terminal")
  ;; IDE contextual
  ("i" mu/open-ide "ide")  ;; era (call-interactively mu/contextual-ide)
  ;; Version control
  ("v" magit-status "magit")
  ;; Utilidades
  ("s" save-buffer "guardar")
  ("q" (switch-to-buffer (other-buffer (current-buffer))) "anterior"))

(defun mu/open-dispatcher ()
  "Abrir el dispatcher."
  (interactive)
  (let ((hydra-is-helpful t))
    (call-interactively 'mu/dispatcher/body)))

(provide 'facusmzi-dispatcher)
;;; mu-dispatcher.el ends here
