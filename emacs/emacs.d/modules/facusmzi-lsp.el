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
  (lsp-auto-guess-root t)
  (lsp-keymap-prefix nil)
  (lsp-diagnostics-provider :flycheck)
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
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-doc-alignment 'window)
  :hook (lsp-mode . lsp-ui-mode))

;; Completado
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :config
  (global-corfu-mode))

;; Debugging
(use-package dap-mode
  :custom
  (dap-auto-configure-features nil)
  (dap-ui-buffer-configurations nil)
  :config
  (require 'dap-ui)
  (dap-mode 1)
  (dap-auto-configure-mode 1))

(defhydra mu/dap-dispatcher (:color teal :hint nil)
  "Debugger"
  ("<f12>" keyboard-escape-quit)
  ("b" dap-breakpoint-toggle "breakpoint")
  ("c" dap-continue "continuar")
  ("l" dap-go-to-output-buffer "log")
  ("L" dap-ui-locals "locales")
  ("B" dap-ui-breakpoints "breakpoints")
  ("n" dap-next "next" :color red)
  ("s" dap-step-in "step" :color red))

(provide 'facusmzi-lsp)
;;; facusmzi-lsp.el ends here
