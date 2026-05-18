;;; facusmzi-window.el --- manejo de ventanas y popups -*- lexical-binding: t; -*-

;; Shackle: controla dónde se abren los buffers
(use-package shackle
  :config
  (setq shackle-rules
        '(;; Compilación y errores — abajo, 30% de altura
          ("*compilation*"          :align below :size 0.3 :noselect t)
          ("*Flycheck errors*"      :align below :size 0.25 :noselect t)
          ("*Warnings*"             :align below :size 0.2  :noselect t)
          ("*Backtrace*"            :align below :size 0.4)

          ;; Ayuda — abajo, seleccionable para leer y cerrar
          ("*Help*"                 :align below :size 0.4 :select t)
          ("*helpful*"              :align below :size 0.4 :select t)

          ;; LSP — abajo
          ("*lsp-help*"             :align below :size 0.4 :select t)
          ("*LSP*"                  :align below :size 0.25 :noselect t)
          ("*lsp-log*"              :align below :size 0.25 :noselect t)

          ;; DAP — abajo
          ("*dap-ui-locals*"        :align below :size 0.35 :select t)
          ("*dap-ui-expressions*"   :align below :size 0.35 :select t)
          ("*dap-ui-breakpoints*"   :align below :size 0.25 :select t)
          ("*debug*"                :align below :size 0.25 :noselect t)

          ;; Magit — ventana entera aparte (comportamiento habitual de magit)
          (magit-status-mode        :align right  :size 0.5  :select t)
          (magit-log-mode           :align right  :size 0.5  :select t)
          (magit-diff-mode          :align right  :size 0.5  :select t)

          ;; Grep / búsqueda
          ("*grep*"                 :align below :size 0.3 :select t)
          ("*rg*"                   :align below :size 0.3 :select t)
          ("*xref*"                 :align below :size 0.3 :select t)

          ;; Otros
          ("*eshell*"               :align below :size 0.35 :select t)
          ("*eat*"                  :align below :size 0.35 :select t)
          ("*Messages*"             :align below :size 0.25 :noselect t)))

  ;; El fallback: si nada matchea, abrir abajo
  (setq shackle-default-rule '(:align below :size 0.3))

  (shackle-mode 1))

;; Resize de ventanas desde el dispatcher
;; Estas funciones son llamadas por facusmzi-dispatcher con :color red
(defun mu/window-enlarge-horizontal ()
  "Agrandar ventana horizontalmente."
  (interactive)
  (enlarge-window-horizontally 4))

(defun mu/window-shrink-horizontal ()
  "Achicar ventana horizontalmente."
  (interactive)
  (shrink-window-horizontally 4))

(defun mu/window-enlarge-vertical ()
  "Agrandar ventana verticalmente."
  (interactive)
  (enlarge-window 2))

(defun mu/window-shrink-vertical ()
  "Achicar ventana verticalmente."
  (interactive)
  (shrink-window 2))

(provide 'facusmzi-window)
;;; facusmzi-window.el ends here
