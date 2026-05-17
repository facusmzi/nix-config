;;; user-reading.el --- PDF y EPUB -*- lexical-binding: t -*-

;; pdf-tools reemplaza DocView con renderizado nativo via poppler.
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . pdf-view-midnight-minor-mode)
  :config
  (pdf-tools-install :no-query)

  ;; Cerrar el buffer de pdf-occur al saltar a un resultado con Enter
  (advice-add 'pdf-occur-goto-occurrence :after
              (lambda (&rest _)
                (when-let (win (get-buffer-window "*PDF-Occur*"))
                  (delete-window win))))

  (add-to-list 'display-buffer-alist
               '("\\*PDF-Occur\\*"
                 (display-buffer-reuse-window display-buffer-below-selected)
                 (window-height . 0.3)
                 (inhibit-same-window . t)))

  (add-hook 'pdf-occur-buffer-mode-hook
            (lambda ()
              (run-with-idle-timer 0 nil
                (lambda ()
                  (when-let (win (get-buffer-window "*PDF-Occur*"))
                    (select-window win))))))

  :bind (:map pdf-view-mode-map
              ("j"   . pdf-view-next-line-or-next-page)
              ("k"   . pdf-view-previous-line-or-previous-page)
              ("C-+" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink)))

;; Restaura la última página visitada al reabrir un PDF.
(use-package pdf-view-restore
  :after pdf-tools
  :hook (pdf-view-mode . pdf-view-restore-mode))

;; nov.el renderiza EPUBs con fuente variable-pitch.
(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  :custom
  (nov-text-width 80))

(provide 'user-reading)
;;; user-reading.el ends here
