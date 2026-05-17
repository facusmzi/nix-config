;;; user-org.el --- Org mode -*- lexical-binding: t -*-

(use-package org
  :hook (org-mode . org-indent-mode)
  :custom
  (org-return-follows-link t))

(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode))

;; org-download permite pegar imágenes del clipboard directamente en el .org.
;; Flujo: sacar captura con grim → C-c i p → imagen guardada en ./img/ e insertada.
(use-package org-download
  :after org
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "./img")
  (org-download-heading-lvl nil)
  :bind (:map org-mode-map
              ("C-c i p" . org-download-clipboard)))

(provide 'user-org)
;;; user-org.el ends here
