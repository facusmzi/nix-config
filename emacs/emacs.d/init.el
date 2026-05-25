;;; init.el -*- lexical-binding: t; -*-


;; ============================================================
;; INTERFAZ MÍNIMA
;; ============================================================

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default cursor-in-non-selected-windows nil)
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)   ;; Nada de beeps


;; ============================================================
;; COMPORTAMIENTO DEL EDITOR
;; ============================================================

(electric-pair-mode 1)        ;; Cierra paréntesis/corchetes/comillas automáticamente
(show-paren-mode 1)           ;; Resalta el par del paréntesis bajo el cursor
(global-auto-revert-mode 1)   ;; Recarga archivos modificados fuera de Emacs
(delete-selection-mode 1)     ;; Escribir sobre una selección la reemplaza
(fset 'yes-or-no-p 'y-or-n-p) ;; y/n en vez de yes/no

(setq-default indent-tabs-mode nil)  ;; Usa espacios, no tabs
(setq-default tab-width 4)

(global-display-line-numbers-mode 1)
(column-number-mode 1)


;; ============================================================
;; HISTORIAL Y ARCHIVOS RECIENTES
;; ============================================================

(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Guarda la posición del cursor al cerrar archivos
(save-place-mode 1)


;; ============================================================
;; BACKUPS
;; Redirige los archivos file~ y #file# a /tmp para no ensuciar
;; los directorios de trabajo
;; ============================================================

(setq make-backup-files nil)
(setq auto-save-default nil)

;; Alternativa: guardarlos en un directorio centralizado
;; (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))


;; ============================================================
;; TEMA: Dracula
;; ============================================================

(load-theme 'dracula t)


;; ============================================================
;; WHICH-KEY
;; Muestra los atajos disponibles al pausar una combinación
;; Ej: C-x <pausa> → lista todas las opciones de C-x
;; ============================================================

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))


;; ============================================================
;; COMPLETION EN MINIBUFFER
;; vertico   → lista vertical
;; orderless → búsqueda fuzzy en cualquier orden
;; marginalia → anotaciones (docstrings, permisos, etc.)
;; consult   → comandos mejorados (buffers, grep, ripgrep...)
;; ============================================================

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("C-c r"   . consult-recent-file)
         ("C-c f"   . consult-fd)         ;; Buscar archivos con fd
         ("C-c g"   . consult-ripgrep)    ;; Grep con ripgrep en el proyecto
         ("C-c l"   . consult-line)       ;; Buscar línea en el buffer actual
         ("C-x C-f" . find-file)))


;; ============================================================
;; COMPLETION EN BUFFER (Corfu)
;; Autocompletado inline en el punto de inserción,
;; mucho más ligero que company-mode
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)           ;; Activa el popup automáticamente
  (corfu-auto-delay 0.2)   ;; Espera 200ms antes de mostrar sugerencias
  (corfu-quit-no-match t)  ;; Cierra el popup si no hay coincidencias
  :init
  (global-corfu-mode))




;; ============================================================
;; MAGIT
;; El mejor cliente Git que existe.
;; C-x g  → panel de status
;; s       → stage   |  u → unstage
;; c c     → commit  |  P p → push  |  F p → pull
;; b b     → branch  |  ? → ayuda completa
;; ============================================================

(use-package magit
  :bind ("C-x g" . magit-status))


;; ============================================================
;; ENVRC
;; Integra direnv: carga el entorno del .envrc de cada proyecto
;; Esencial con nix develop / nix shell
;; ============================================================

(use-package envrc
  :init
  (envrc-global-mode))


;; ============================================================
;; GPTEL (AI en Emacs)
;; C-c RET → enviar prompt al LLM desde cualquier buffer
;; M-x gptel → abrir buffer de chat dedicado
;; ============================================================

(use-package gptel
  :ensure t
  :config
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))
  (setq gptel-model 'gpt-4o)
  :bind (("C-c <return>" . gptel-send)
         ("C-c C-<return>" . gptel)))




;; ============================================================
;; EGLOT (LSP)
;; ============================================================

(use-package eglot
  :hook ((haskell-mode . eglot-ensure)
         (nix-mode     . eglot-ensure))
  :bind (:map eglot-mode-map
              ("M-."   . xref-find-definitions)
              ("M-,"   . xref-go-back)
              ("C-c a" . eglot-code-actions)
              ("C-c r" . eglot-rename)))
