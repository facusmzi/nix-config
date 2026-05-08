;; Allow tangling if the file is a symlink
(setq vc-follow-symlinks nil)
;; Forzar regeneración del .el desde el .org
(delete-file
  (expand-file-name "config.el" user-emacs-directory))
;; Tangle el .org y cargarlo
(org-babel-load-file
  (expand-file-name "config.org" user-emacs-directory))
