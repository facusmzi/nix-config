;;; init.el -*- lexical-binding: t; -*-
;; Activa lexical binding: mejora performance y es la forma moderna de escribir Elisp

;; ============================================================
;; BOOTSTRAP: use-package
;; En NixOS los paquetes se declaran en home.nix (o similar),
;; no desde Emacs. use-package ya viene disponible vía nix.
;; Si alguna vez migrás a otra distro, descomentá el bloque
;; de MELPA de abajo para instalar todo desde Emacs.
;; ============================================================

(require 'use-package)
;; En NixOS no necesitamos :ensure t — nix ya instaló todo.
;; Descomentá esto solo si instalás paquetes desde Emacs:
;; (setq use-package-always-ensure t)

;; -- ALTERNATIVA (no-NixOS) ----------------------------------
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (setq use-package-always-ensure t)
;; ------------------------------------------------------------


;; ============================================================
;; STARTUP: acelerar el arranque (de colonq/init.el)
;; Sube temporalmente el umbral de GC durante el init,
;; después lo restaura al final del archivo.
;; ============================================================

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)


;; ============================================================
;; INTERFAZ MÍNIMA
;; ============================================================

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(tooltip-mode -1)
(setq-default cursor-in-non-selected-windows nil
              bidi-display-reordering nil)    ;; mejora performance en buffers largos
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      sentence-end-double-space nil
      custom-file "/dev/null"                ;; tira las customizaciones en /dev/null
      confirm-kill-emacs 'y-or-n-p)         ;; pide confirmación al salir


;; ============================================================
;; COMPORTAMIENTO DEL EDITOR
;; ============================================================

(electric-pair-mode 1)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)
(setq scroll-step 1)             ;; scroll más suave, sin saltos


;; ============================================================
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

(global-display-line-numbers-mode 1)
(column-number-mode 1)


;; ============================================================
;; HISTORIAL Y ARCHIVOS RECIENTES
;; ============================================================

(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items nil)  ;; guarda toda la lista, sin límite


;; ============================================================
;; BACKUPS
;; ============================================================

(setq make-backup-files nil
      auto-save-default nil)


;; ============================================================
;; TEMA
;; ============================================================

(use-package dracula-theme
  :config
  (load-theme 'dracula t))


;; ============================================================
;; WHICH-KEY
;; ============================================================

(use-package which-key
  :config
  (which-key-mode))


;; ============================================================
;; UNDO-TREE
;; Sistema de undo no-lineal (árbol en vez de lista).
;; Necesario para el :undo-system de evil.
;; Desactivamos el autoguardado del historial — genera archivos
;; de undo en todos lados.
;; ============================================================

(use-package undo-tree
  :custom
  (undo-tree-auto-save-history nil)
  :config
  (global-undo-tree-mode))


;; ============================================================
;; EVIL MODE
;; ============================================================

(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)      ;; evil-collection maneja buffers especiales
  (evil-want-C-u-scroll t)
  (evil-want-minibuffer t)        ;; evil en el minibuffer (de colonq)
  (evil-undo-system 'undo-tree)   ;; usa undo-tree como backend
  (evil-auto-balance-windows nil) ;; no rebalancear ventanas automáticamente
  :config
  (evil-mode 1)

  ;; Estados iniciales para buffers especiales (de colonq)
  ;; motion-state: hjkl funcionan, pero no insert/d/c/etc.
  (evil-set-initial-state 'magit-status-mode  'motion)
  (evil-set-initial-state 'magit-diff-mode    'motion)
  (evil-set-initial-state 'magit-stashes-mode 'motion)
  (evil-set-initial-state 'compilation-mode   'motion)
  (evil-set-initial-state 'special-mode       'motion)
  (evil-set-initial-state 'Info-mode          'motion)

  ;; Liberar "q" → dispatcher (ver sección HYDRA)
  ;; Macros → "m" (en Vim vanilla "m" pone marcas, quedan en M-<letra>)
  (define-key evil-normal-state-map (kbd "m") 'evil-record-macro)

  ;; ":" no hace nada por defecto — la abrimos en el dispatcher si la necesitamos
  (define-key evil-normal-state-map (kbd ":") nil)
  (define-key evil-motion-state-map (kbd ":") nil)
  (define-key evil-visual-state-map (kbd ":") nil)

  ;; "#" comenta/descomenta la selección o línea (de colonq)
  (define-key evil-normal-state-map (kbd "#") #'comment-dwim)
  (define-key evil-visual-state-map (kbd "#") #'comment-dwim)

  ;; 0 → primer caracter no-blanco (más útil en código)
  (define-key evil-normal-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "0") 'evil-first-non-blank))


;; ============================================================
;; EVIL-COLLECTION
;; Keybindings Evil para buffers que evil base no cubre:
;; Magit, Dired, corfu, helpful, etc.
;; ============================================================

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; ============================================================
;; DIRED
;; evil-collection pisa "q" en dired con quit-window.
;; Recreamos el keymap y lo reasignamos explícitamente.
;; ============================================================

(use-package dired
  :custom
  (dired-dwim-target t)           ;; sugiere el otro dired abierto como destino
  (dired-listing-switches "-lvah")
  :config
  (defun my/dired-find-file ()
    "Abre directorio sin crear un nuevo buffer (reemplaza el actual)."
    (interactive)
    (if (file-directory-p (dired-get-file-for-visit))
        (dired-find-alternate-file)
      (dired-find-file)))
  (defun my/dired-up-directory ()
    "Sube un nivel sin acumular buffers."
    (interactive)
    (let ((buf (current-buffer)))
      (dired-up-directory)
      (kill-buffer buf)))

  (setq dired-mode-map (make-keymap))
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-define-key 'motion dired-mode-map
    (kbd "q")   'my/dispatcher/body
    (kbd "RET") 'my/dired-find-file
    (kbd "u")   'my/dired-up-directory
    (kbd "SPC") 'dired-mark
    (kbd "x")   'dired-do-delete
    (kbd "d")   'dired-do-rename
    (kbd "y")   'dired-do-copy
    (kbd "R")   'revert-buffer)

  (defun my/dired-setup ()
    (hl-line-mode)
    (dired-hide-details-mode))
  (add-hook 'dired-mode-hook 'my/dired-setup))


;; ============================================================
;; ESCAPE UNIVERSAL
;; <Escape> hace lo correcto según el contexto, sin cerrar
;; ventanas como efecto secundario (bug de Emacs por defecto).
;; ============================================================

(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () ())))
    ad-do-it))

(defun my/escape ()
  "Escape universal estilo Vim."
  (interactive)
  (cond
   ((minibufferp)
    (keyboard-escape-quit))
   ((and (bound-and-true-p corfu-mode) corfu--candidates)
    (corfu-quit))
   ((or (evil-insert-state-p) (evil-replace-state-p))
    (evil-normal-state))
   ((evil-visual-state-p)
    (evil-exit-visual-state))
   (t
    (keyboard-quit))))

(global-set-key (kbd "<escape>") #'my/escape)


;; ============================================================
;; MOVIMIENTO ENTRE VENTANAS
;; M-hjkl funciona en cualquier modo, incluyendo Magit y Dired
;; ============================================================

(global-set-key (kbd "M-h") #'windmove-left)
(global-set-key (kbd "M-l") #'windmove-right)
(global-set-key (kbd "M-k") #'windmove-up)
(global-set-key (kbd "M-j") #'windmove-down)


;; ============================================================
;; HYDRA + DISPATCHER EN "q"
;;
;; Apretás q → panel instantáneo con todas las opciones.
;; :color teal → cada tecla ejecuta y cierra el panel.
;; :color red  → la tecla se puede repetir (ej: zoom, resize).
;; :hint nil   → usamos el string manual de arriba en vez del
;;               hint autogenerado (más control visual).
;; ============================================================

(use-package hydra)

;; Sub-dispatcher para Version Control (inspirado en colonq/colonq-vc.el)
(defhydra my/vc-dispatcher (:color teal :hint nil)
  "
  Git
  ──────────────────────────────────────
  _v_ status      _l_ log         _b_ blame
  _h_ file log    _d_ diff        _s_ switch branch
  _c_ commit      _p_ push        _u_ pull
  _q_ volver      _<escape>_ cancelar
  "
  ("v" magit-status)
  ("h" magit-log-buffer-file)
  ("l" magit-log-current)
  ("d" (magit-diff-range "HEAD"))
  ("b" magit-blame-addition)
  ("s" magit-checkout)
  ("c" magit-commit-create)
  ("p" magit-push-current-to-upstream)
  ("u" magit-pull-from-upstream)
  ("q" my/dispatcher/body)
  ("<escape>" nil))

;; Sub-dispatcher para Eglot / LSP (Haskell y lo que agregues)
(defhydra my/lsp-dispatcher (:color teal :hint nil)
  "
  LSP (Eglot)
  ──────────────────────────────────────
  _d_ ir a definición    _r_ referencias
  _n_ renombrar símbolo  _a_ code actions
  _e_ siguiente error    _f_ formatear
  _q_ volver             _<escape>_ cancelar
  "
  ("d" xref-find-definitions)
  ("r" xref-find-references)
  ("n" eglot-rename)
  ("a" eglot-code-actions)
  ("e" flymake-goto-next-error)
  ("f" eglot-format)
  ("q" my/dispatcher/body)
  ("<escape>" nil))

;; Dispatcher principal
(defhydra my/dispatcher (:color teal :hint nil)
  "
  Dispatcher
  ──────────────────────────────────────────────────────
  Archivos            Buffers             Texto
  _f_ abrir           _b_ cambiar         _/_ buscar proyecto
  _r_ recientes       _k_ cerrar          _l_ buscar buffer
  _s_ guardar         _q_ buffer anterior _+_ zoom+ _-_ zoom-
  ──────────────────────────────────────────────────────
  Ventanas            Código              Ayuda
  _1_ solo esta       _g_ git             _hf_ función
  _2_ dividir ↓       _i_ lsp             _hv_ variable
  _3_ dividir →       _<escape>_ cancelar _hk_ tecla
  "
  ;; Archivos
  ("f" find-file)
  ("r" consult-recent-file)
  ("s" save-buffer)

  ;; Buffers
  ("b" consult-buffer)
  ("k" kill-current-buffer)
  ("q" (switch-to-buffer (other-buffer)))

  ;; Búsqueda
  ("/" consult-ripgrep)
  ("l" consult-line)

  ;; Ventanas
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)

  ;; Zoom (red: se puede repetir sin cerrar el hydra)
  ("+" (text-scale-increase 1) :color red)
  ("=" (text-scale-increase 1) :color red)
  ("-" (text-scale-increase -1) :color red)

  ;; Sub-dispatchers
  ("g" my/vc-dispatcher/body)
  ("i" my/lsp-dispatcher/body)

  ;; Ayuda
  ("hf" helpful-callable)
  ("hv" helpful-variable)
  ("hk" helpful-key)

  ("<escape>" nil))

;; Asignar dispatcher a "q" en normal, motion y emacs state
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "q") 'my/dispatcher/body)
  (define-key evil-motion-state-map (kbd "q") 'my/dispatcher/body)
  (define-key evil-emacs-state-map  (kbd "q") 'my/dispatcher/body))


;; ============================================================
;; STACK DE COMPLETION MODERNO
;; ============================================================

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic)))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind
  ("C-x b" . consult-buffer))


;; ============================================================
;; CORFU
;; Completion inline para código, LSP, dabbrev.
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  :init (global-corfu-mode))


;; ============================================================
;; EGLOT (LSP)
;; Built-in desde Emacs 29. Agrega ir a definición, errores
;; en tiempo real, renombrar símbolos, etc.
;; El language server de Haskell (haskell-language-server)
;; debe estar disponible en el PATH — en NixOS va en home.nix.
;; ============================================================

(use-package eglot
  :hook
  ((haskell-mode . eglot-ensure))
  ;; Para agregar más lenguajes, sumá una línea:
  ;; (python-mode . eglot-ensure)
  ;; (js-mode     . eglot-ensure)
  )


;; ============================================================
;; HASKELL-MODE
;; ============================================================

(use-package haskell-mode)


;; ============================================================
;; FLYMAKE
;; Eglot lo usa internamente para mostrar errores.
;; read-process-output-max mejora el throughput con LSP.
;; ============================================================

(setq read-process-output-max (* 1024 1024))

(use-package flymake
  :hook (prog-mode . flymake-mode))


;; ============================================================
;; HELPFUL
;; ============================================================

(use-package helpful
  :bind
  ("C-h f" . helpful-callable)
  ("C-h v" . helpful-variable)
  ("C-h k" . helpful-key))


;; ============================================================
;; WGREP
;; Editar resultados de consult-ripgrep como si fuera un buffer.
;; ============================================================

(use-package wgrep)


;; ============================================================
;; MAGIT
;; q g → vc-dispatcher → v = magit-status
;; C-x g también funciona como fallback directo.
;; ============================================================

(use-package magit
  :custom
  (magit-no-message '("Turning on"))
  :bind ("C-x g" . magit-status)
  :config
  ;; Solo pisamos "q" — el resto (s, u, x, TAB, etc.) lo deja
  ;; evil-collection intacto. Resetear el keymap entero rompe staging.
  (evil-define-key 'motion magit-mode-map
    (kbd "q") 'my/dispatcher/body)
  (evil-define-key 'normal magit-mode-map
    (kbd "q") 'my/dispatcher/body))


;; ============================================================
;; ENVRC
;; Integra direnv / nix develop / nix shell con Emacs.
;; ============================================================

(use-package envrc
  :init
  (envrc-global-mode))


;; ============================================================
;; GPTEL + COPILOT
;; ============================================================

(use-package gptel
  :config
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))
  (setq gptel-model 'gpt-4o))


;; ============================================================
;; RESTAURAR GC (debe ir al final del archivo)
;; ============================================================

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist my/file-name-handler-alist)
