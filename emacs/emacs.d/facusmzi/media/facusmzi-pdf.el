;;; facusmzi-pdf --- PDF reader -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-evil)

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (define-key pdf-view-mode-map (kbd "q") nil)
  (evil-define-key 'motion pdf-view-mode-map
    "h"  'scroll-right
    "l"  'scroll-left
    "j"  'pdf-view-next-line-or-next-page
    "k"  'pdf-view-previous-line-or-previous-page
    "J"  'pdf-view-scroll-up-or-next-page
    "K"  'pdf-view-scroll-down-or-previous-page
    "]"  'pdf-view-next-page-command
    "["  'pdf-view-previous-page-command
    "-"  'pdf-view-shrink
    "+"  'pdf-view-enlarge
    "gj" 'pdf-view-next-page-command
    "gk" 'pdf-view-previous-page-command
    "gg" 'pdf-view-first-page
    "G"  'pdf-view-last-page
    "d"  'pdf-view-kill-ring-save
    "y"  'pdf-view-kill-ring-save
    [down-mouse-1] 'pdf-view-mouse-set-region)

  ;; Sin cursor visible en pdf-view
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (set (make-local-variable 'evil-normal-state-cursor)
                   (list nil)))))

;; Abrir PDFs con Okular en vez de dentro de Emacs
;; (Okular ya es el default en plasma.nix via xdg.mimeApps)
(defun facusmzi/pdf-find-file-wrapper (f &rest args)
  "Wrapper sobre F (find-file): abre PDFs con Okular."
  (if (and (car args) (string= (file-name-extension (car args)) "pdf"))
      (progn
        (start-process "okular" nil "okular" (car args))
        (recentf-add-file (car args))
        nil)
    (apply f args)))
(advice-add 'find-file :around #'facusmzi/pdf-find-file-wrapper)

(provide 'facusmzi-pdf)
;;; facusmzi-pdf.el ends here
