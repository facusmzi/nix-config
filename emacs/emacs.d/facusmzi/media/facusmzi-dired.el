;;; facusmzi-dired --- file manager -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)

(use-package dired
  :custom
  (dired-dwim-target t)                          ; operaciones en dos paneles inteligentes
  (dired-listing-switches "-lvah")               ; listar con detalles y tamaños legibles
  (dired-hide-details-preserved-columns '(1 3 5 6 7 8))
  :config

  (defun facusmzi/dired-find-file ()
    "Abrir archivo o entrar en directorio (reusar buffer)."
    (interactive)
    (if (file-directory-p (dired-get-file-for-visit))
        (dired-find-alternate-file)
      (dired-find-file)))

  (defun facusmzi/dired-up-directory ()
    "Subir un directorio matando el buffer actual."
    (interactive)
    (let ((buf (current-buffer)))
      (dired-up-directory)
      (kill-buffer buf)))

  (defun facusmzi/dired-thumbnails ()
    "Abrir image-dired para el directorio actual."
    (interactive)
    (let ((thumbnail-buf (concat "*thumbnails " (dired-current-directory) "*")))
      (if (get-buffer thumbnail-buf)
          (switch-to-buffer thumbnail-buf)
        (let ((buf (current-buffer)))
          (image-dired (dired-current-directory))
          (rename-buffer thumbnail-buf)
          (with-current-buffer buf
            (dired-unmark-all-marks))))))

  ;; Keymap limpio — sin bindings default de dired
  (setq dired-mode-map (make-keymap))
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-define-key 'motion dired-mode-map
    (kbd "q")   'facusmzi/dispatcher
    (kbd "SPC") 'dired-mark
    (kbd "RET") 'facusmzi/dired-find-file
    (kbd "u")   'facusmzi/dired-up-directory
    (kbd "o")   'dired-create-directory
    (kbd "x")   'dired-do-delete
    (kbd "d")   'dired-do-rename
    (kbd "y")   'dired-do-copy
    (kbd "i")   'facusmzi/dired-thumbnails
    (kbd "R")   'revert-buffer)

  (defun facusmzi/dired-setup ()
    (hl-line-mode)
    (dired-hide-details-mode))
  (add-hook 'dired-mode-hook 'facusmzi/dired-setup))

;; ─── image-dired ───────────────────────────────────────────

(use-package image-dired
  :config
  (setq image-dired-show-all-from-dir-max-files 1000)

  (defun facusmzi/image-dired-find-file ()
    (interactive)
    (find-file (image-dired-original-file-name)))

  (defun facusmzi/image-dired-delete ()
    (interactive)
    (let ((path (image-dired-original-file-name)))
      (when (yes-or-no-p (concat "¿Borrar " path "?"))
        (delete-file path))))

  (setq image-dired-thumbnail-mode-map (make-keymap))
  (evil-set-initial-state 'image-dired-thumbnail-mode 'motion)
  (evil-define-key 'motion image-dired-thumbnail-mode-map
    (kbd "h")   'image-dired-backward-image
    (kbd "b")   'image-dired-backward-image
    (kbd "l")   'image-dired-forward-image
    (kbd "w")   'image-dired-forward-image
    (kbd "e")   'image-dired-forward-image
    (kbd "k")   'image-dired-previous-line
    (kbd "j")   'image-dired-next-line
    (kbd "x")   'facusmzi/image-dired-delete
    (kbd "RET") 'facusmzi/image-dired-find-file))

(provide 'facusmzi-dired)
;;; facusmzi-dired.el ends here
