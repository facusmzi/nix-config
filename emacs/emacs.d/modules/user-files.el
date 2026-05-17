;;; user-files.el --- Archivos, sesión e historial -*- lexical-binding: t -*-

(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; desktop-save nil desactiva el guardado automático al cerrar —
;; solo se guarda cuando se usa C-c q explícitamente.
(desktop-save-mode 1)
(setq desktop-save nil
      desktop-dirname (locate-user-emacs-file "")
      desktop-restore-frames t
      desktop-load-locked-desktop t)

(defun user/save-and-quit ()
  "Guarda la sesión de desktop y cierra Emacs."
  (interactive)
  (dolist (buf (buffer-list))
    (when (eq (buffer-local-value 'major-mode buf) 'eat-mode)
      (let ((proc (get-buffer-process buf)))
        (when proc (delete-process proc)))))
  (desktop-save user-emacs-directory t)
  (save-buffers-kill-terminal))

(defun user/clean-quit ()
  "Borra la sesión guardada y cierra Emacs (arranca desde cero la próxima vez)."
  (interactive)
  (let ((f (expand-file-name ".emacs.desktop" user-emacs-directory)))
    (when (file-exists-p f)
      (delete-file f)))
  (save-buffers-kill-terminal))

(global-set-key (kbd "C-c q") #'user/save-and-quit)
(global-set-key (kbd "C-x C-c") #'user/clean-quit)

;; Volver al último buffer usado
(global-set-key (kbd "C-x ,") #'mode-line-other-buffer)

;;; Historial
(recentf-mode 1)
(setq history-length 25)
(savehist-mode 1)

;;; Clipboard — sincronizar con el sistema (clave para pgtk + Wayland)
(setq select-enable-clipboard t
      select-enable-primary t)

(provide 'user-files)
;;; user-files.el ends here
