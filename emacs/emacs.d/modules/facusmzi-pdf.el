;;; facusmzi-pdf.el --- lector de PDFs -*- lexical-binding: t; -*-

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (evil-set-initial-state 'pdf-view-mode 'motion)
  (evil-define-key 'motion pdf-view-mode-map
    (kbd "j")   #'pdf-view-next-line-or-next-page
    (kbd "k")   #'pdf-view-previous-line-or-previous-page
    (kbd "J")   #'pdf-view-scroll-up-or-next-page
    (kbd "K")   #'pdf-view-scroll-down-or-previous-page
    (kbd "]")   #'pdf-view-next-page-command
    (kbd "[")   #'pdf-view-previous-page-command
    (kbd "gg")  #'pdf-view-first-page
    (kbd "G")   #'pdf-view-last-page
    (kbd "+")   #'pdf-view-enlarge
    (kbd "-")   #'pdf-view-shrink))

(provide 'facusmzi-pdf)
;;; facusmzi-pdf.el ends here
