;;; facusmzi-projectile --- project management -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(use-package projectile
  :custom
  ;; Usar completing-read por defecto (lo sobreescribiremos con selector cuando esté)
  (projectile-completion-system 'default)
  :config
  (projectile-mode)

  ;; No explotar con paths remotos (tramp, ssh, etc.)
  (defun facusmzi/projectile-project-root-wrapper (f &rest args)
    "Wrapper sobre F (projectile-project-root), pasando ARGS."
    (unless (file-remote-p default-directory)
      (apply f args)))
  (advice-add 'projectile-project-root :around 'facusmzi/projectile-project-root-wrapper)

  ;; Limpiar el keymap de projectile — no queremos sus bindings globales
  (setf (cdr projectile-mode-map) nil))

(provide 'facusmzi-projectile)
;;; facusmzi-projectile.el ends here
