;;; facusmzi-lsp --- language server protocol -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-flycheck)

;; Aumentar el tamaño del buffer de lectura para respuestas grandes del LSP
(setq read-process-output-max (* 1024 1024))

;; ─── Yasnippet ─────────────────────────────────────────────
;; lsp-mode lo usa para completar snippets de código
(use-package yasnippet
  :config
  (yas-reload-all)
  :hook (lsp-mode . yas-minor-mode))

;; ─── LSP Mode ──────────────────────────────────────────────
(use-package lsp-mode
  :custom
  (lsp-lens-enable nil)            ; sin lentes de código (conteo de refs, etc.)
  (lsp-prefer-flymake nil)         ; usar flycheck, no flymake
  (lsp-enable-snippet t)
  (lsp-eldoc-render-all t)
  :config
  (defun facusmzi/lsp-setup ()
    ;; En buffers con LSP activo, K muestra la doc del eldoc buffer
    (setq-local facusmzi/contextual-lookup #'eldoc)
    (setq-local eldoc-display-functions '(eldoc-display-in-buffer)))
  (add-hook 'lsp-mode-hook #'facusmzi/lsp-setup))

;; ─── LSP UI ────────────────────────────────────────────────
(use-package lsp-ui
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-enable nil)     ; sin anotaciones en el margen lateral
  (lsp-ui-doc-delay 0)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-doc-alignment 'window)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse t)
  :hook (lsp-mode . lsp-ui-mode)
  :config
  ;; Hacer que el fondo del popup de doc coincida con el tema
  (ef-themes-with-colors
    (set-face-attribute 'lsp-ui-doc-background nil :background bg-main)))

(provide 'facusmzi-lsp)
;;; facusmzi-lsp.el ends here
