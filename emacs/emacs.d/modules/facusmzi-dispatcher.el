;;; mu-dispatcher.el --- dispatcher -*- lexical-binding: t; -*-

(use-package hydra)

(defhydra mu/dispatcher (:color teal :hint nil)
  "Dispatcher"
  ;; Buffers
  ("o" switch-to-buffer "buffer")
  ("f" find-file "archivo")
  ("r" recentf-open-files "recientes")
  ("k" (let ((kill-buffer-query-functions '(buffer-modified-p)))
         (kill-buffer (current-buffer))) "cerrar")
  ;; Ventanas
  ("\"" (progn (evil-window-vsplit) (windmove-right)) "vsplit")
  ("%" (progn (evil-window-split) (windmove-down)) "split")
  ("w" delete-window "cerrar ventana")
  ;; Terminal
  ("t" mu/term-here "terminal")
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
