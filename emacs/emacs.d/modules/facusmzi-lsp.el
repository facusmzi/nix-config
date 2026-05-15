;;; facusmzi-lsp.el --- language server protocol -*- lexical-binding: t; -*-

(use-package yasnippet
  :config
  (yas-reload-all)
  :hook (lsp-mode . yas-minor-mode))

(setq read-process-output-max (* 1024 1024))

(use-package lsp-mode
  :custom
  (lsp-lens-enable nil)
  (lsp-prefer-flymake nil)
  (lsp-enable-snippet t)
  (lsp-eldoc-render-all t)
  :config
  (defun mu/lsp-setup ()
    (setq-local eldoc-display-functions '(eldoc-display-in-buffer)))
  (add-hook 'lsp-mode-hook #'mu/lsp-setup))

(use-package lsp-ui
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor t)
  :hook (lsp-mode . lsp-ui-mode))

;; Completado
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :config
  (global-corfu-mode))

(provide 'facusmzi-lsp)
;;; facusmzi-lsp.el ends here
