;;; facusmzi-projectile.el --- manejo de proyectos -*- lexical-binding: t; -*-

(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'default  ;; usa vertico
        projectile-switch-project-action #'projectile-dired
        projectile-ignored-project-function
        (lambda (path)
          (file-remote-p path))))

(provide 'facusmzi-projectile)
;;; facusmzi-projectile.el ends here
