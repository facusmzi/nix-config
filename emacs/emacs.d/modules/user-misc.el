;;; user-misc.el --- Dashboard, Eat, Sudo Edit -*- lexical-binding: t -*-

;;; Dashboard
(use-package dashboard
  :config
  (setq dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-startup-banner 'logo
        dashboard-projects-backend 'projectile
        dashboard-projects-switch-function 'projectile-find-file
        dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 5)))
  ;; No arrancar dashboard si hay una sesión de desktop guardada —
  ;; desktop-save-mode la restaura primero y dashboard la sobreescribiría.
  (unless (file-exists-p (expand-file-name ".emacs.desktop" user-emacs-directory))
    (dashboard-setup-startup-hook)))

;;; Eat (Emulate A Terminal)
;; Soporta xterm-256color, mouse e imágenes inline.
;; envrc se encarga de que el shell vea el entorno del devshell activo.
(use-package eat
  :hook
  (eshell-load . eat-eshell-mode)

  :custom
  (eat-shell shell-file-name)

  :bind
  ("C-c t t" . eat)
  ("C-c t p" . eat-project)

  :config
  (defun user/eat-desktop-save (_desktop-dirname)
    "Guarda el directorio del buffer de eat para desktop."
    (list default-directory))

  (defun user/eat-desktop-restore (_file-name _buffer-name misc)
    "Restaura un buffer de eat desde el desktop."
    (let ((default-directory (or (car misc) default-directory)))
      (eat)))

  (add-hook 'eat-mode-hook
            (lambda ()
              (setq-local desktop-save-buffer #'user/eat-desktop-save)))

  (add-to-list 'desktop-buffer-mode-handlers
               '(eat-mode . user/eat-desktop-restore)))

;;; Sudo Edit
(use-package sudo-edit :defer t)

(provide 'user-misc)
;;; user-misc.el ends here
