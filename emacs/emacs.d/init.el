;;; init.el -*- lexical-binding: t; -*-
;; Activa lexical binding, mejora performance y es la forma moderna de escribir Elisp

;; ============================================================
;; INTERFAZ MÍNIMA;; Saca todos los elementos visuales innecesarios de Emacs
;; ============================================================

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; Arranca maximizado
(menu-bar-mode -1)                                            ;; Saca la barra de menú (File, Edit, etc.)
(tool-bar-mode -1)                                            ;; Saca la barra de íconos
(scroll-bar-mode -1)                                          ;; Saca la barra de scroll lateral
(setq-default cursor-in-non-selected-windows nil)             ;; Oculta el cursor en ventanas que no están en foco
(setq inhibit-startup-message t)                              ;; Suprime la pantalla de bienvenida de Emacs


;; ============================================================
;; HISTORIAL Y ARCHIVOS RECIENTES
;; ============================================================

(savehist-mode 1)   ;; Guarda el historial del minibuffer entre sesiones
(recentf-mode 1)    ;; Lleva registro de archivos abiertos recientemente (útil con consult)


;; ============================================================
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

;;(setq display-line-numbers-type 'relative) ;; Números relativos: muestra la distancia desde el cursor
                                           ;; útil para moverse con C-u N C-n/C-p
(global-display-line-numbers-mode 1)       ;; Activa números de línea en todos los buffers
(column-number-mode 1)                     ;; Muestra el número de columna en el modeline


;; ============================================================
;; COMPORTAMIENTO DEL EDITOR
;; ============================================================

(electric-pair-mode 1)      ;; Cierra automáticamente paréntesis, corchetes, comillas, etc.
(show-paren-mode 1)         ;; Resalta el paréntesis/corchete que hace par con el del cursor
(global-auto-revert-mode 1) ;; Recarga automáticamente archivos modificados fuera de Emacs
(fset 'yes-or-no-p 'y-or-n-p) ;; Permite responder y/n en vez de tener que escribir yes/no
(delete-selection-mode 1) ;; Si hay región seleccionada, escribir o pegar la reemplaza directamente

;; ============================================================
;; BACKUPS Y AUTOGUARDADO
;; Emacs por defecto crea archivos file~ y #file# que ensucian
;; ============================================================

(setq make-backup-files nil) ;; No crea archivos de backup (file~)
(setq auto-save-default nil) ;; No crea archivos de autoguardado (#file#)

;;(setq confirm-kill-processes nil) ;; Descommentá para que no pida confirmación al cerrar procesos


;; ============================================================
;; TEMA
;; ============================================================

(load-theme 'dracula t) ;; Carga el tema Dracula (el t suprime la confirmación interactiva)


;; ============================================================
;; WHICH-KEY
;; Muestra un panel con los atajos disponibles cuando pausás una combinación de teclas
;; Ejemplo: apretás C-x y esperás, y te muestra todas las opciones
;; ============================================================

(use-package which-key
  :config
  (which-key-mode))


;; ============================================================
;; COMPLETION MODERNO
;; Stack vertico + orderless + marginalia + consult:
;;   vertico   → lista vertical en el minibuffer
;;   orderless → búsqueda fuzzy/parcial en cualquier orden
;;   marginalia → agrega anotaciones (docstrings, permisos, etc.) a las opciones
;;   consult   → comandos mejorados (buffer switcher, grep, etc.)
;; ============================================================

(use-package vertico
  :init
  (vertico-mode)) ;; Activa el minibuffer vertical

(use-package orderless
  :custom
  (completion-styles '(orderless basic))           ;; Usa orderless como estilo principal
  (completion-category-defaults nil)               ;; Limpia defaults para que orderless tome control
  (completion-category-overrides
   '((file (styles partial-completion)))))          ;; Para rutas de archivo usa partial-completion

(use-package marginalia
  :init
  (marginalia-mode)) ;; Activa las anotaciones en el minibuffer

(use-package consult
  :bind (("C-x b"   . consult-buffer) ;; Reemplaza el switcher de buffers estándar
	 ("C-c r" . consult-recent-file)
         ("C-x C-f" . find-file)))    ;; Mantiene find-file normal (consult lo enriquece igual)


;; ============================================================
;; RAINBOW DELIMITERS
;; Colorea paréntesis/corchetes por nivel de profundidad
;; Muy útil en Elisp y cualquier lenguaje con muchos delimitadores
;; ============================================================

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ;; Se activa solo en modos de programación;;; init.el -*- lexical-binding: t; -*-
;; interfaz mínima
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default cursor-in-non-selected-windows nil)

(savehist-mode 1)
(recentf-mode 1)


;; Muestra columna en el modeline
(column-number-mode 1)

;; electric-pair para cerrar paréntesis automáticamente
(electric-pair-mode 1)

;; líneas y columna
(global-display-line-numbers-mode 1)

(setq inhibit-startup-message t)

;; tema
(load-theme 'dracula t)

(use-package which-key
  :config
  (which-key-mode))

;; backups en una carpeta
(setq make-backup-files nil)
(setq auto-save-default nil)

;; saca la confirmacion de cerrar buffer
;;(setq confirm-kill-processes nil)

;; recargar archivos cambiados afuera de emacs
(global-auto-revert-mode 1)

;; parenthesis matching
(show-paren-mode 1)

;; y/n en vez de yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;;;;;;;; basic

;; ----------------------------
;; completion moderno
;; ----------------------------

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-f" . find-file)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; ============================================================
;; MAGIT
;; Cliente git. C-x g abre el panel principal ("status")
;; Desde ahí: s=stage, c c=commit, P p=push, F p=pull
;; ============================================================

(use-package magit
  :bind ("C-x g" . magit-status))


;; ============================================================
;; CORFU
;; Autocompletado inline mientras escribís (el popup de sugerencias)
;; TAB o Enter para aceptar, M-n/M-p o flechas para navegar
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)          ;; Activa el popup automáticamente sin tener que pedirlo
  (corfu-auto-delay 0.2)  ;; Espera 0.2 segundos antes de mostrar sugerencias
  (corfu-auto-prefix 2)   ;; Empieza a sugerir después de 2 caracteres escritos
  :init
  (global-corfu-mode))    ;; Activa corfu en todos los buffers


;; Conecta lsp-mode con corfu via orderless
(with-eval-after-load 'lsp-mode
  (setq lsp-completion-provider :none)
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))
  (add-hook 'lsp-completion-mode-hook #'my/lsp-mode-setup-completion))


;; ============================================================
;; LSP-MODE — cliente LSP con mejor soporte para .NET/omnisharp
;; M-.                  → ir a definición
;; M-,                  → volver
;; C-c l r r            → renombrar símbolo
;; C-c l a a            → code actions (fix, refactor, etc.)
;; C-c l g r            → ver referencias
;; ============================================================

(use-package lsp-mode
  :hook
  (csharp-mode . lsp)        ;; Activa lsp automáticamente al abrir un .cs
  :custom
  (lsp-auto-guess-root t)    ;; Detecta automáticamente la raíz del proyecto (.sln, .csproj)
  (lsp-keymap-prefix "C-c l");; Prefijo para todos los comandos lsp
  :config
  (lsp-enable-which-key-integration t)
  :commands lsp)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode) ;; Se activa junto con lsp-mode
  :custom
  (lsp-ui-doc-enable t)          ;; Muestra documentación flotante al hover
  (lsp-ui-sideline-enable t))    ;; Muestra errores/warnings al costado de la línea

(use-package csharp-mode
  :mode "\\.cs\\'") ;; Activa csharp-mode para archivos .cs




;; ============================================================
;; HASKELL
;; haskell-mode → soporte base para .hs
;; lsp-haskell  → conecta con HLS (Haskell Language Server)
;; ormolu       → formateador, se ejecuta al guardar
;; REPL         → C-c C-z abre/va al REPL
;;                C-c C-l carga el archivo actual en el REPL
;;                C-c C-e evalúa la expresión en punto
;; HLS y ormolu tienen que estar en el PATH del proyecto,
;; manejalo con un flake.nix que los incluya (envrc lo carga)
;; ============================================================

(setq haskell-mode-ormolu-program "ormolu")
(setq haskell-process-type 'cabal-repl) ;; o 'stack-ghci si usás Stack, o 'ghci para bare GHCi

(use-package haskell-mode
  :mode "\\.hs\\'"
  :hook
  (haskell-mode . interactive-haskell-mode) ;; activa el REPL integrado
  (haskell-mode . (lambda ()
                    (add-hook 'before-save-hook #'haskell-mode-ormolu-format nil t))))

(use-package lsp-haskell
  :hook
  (haskell-mode          . lsp)
  (haskell-literate-mode . lsp))


;; ============================================================
;; ENVRC
;; Integra direnv con Emacs. Carga automáticamente el entorno
;; definido en el .envrc de cada proyecto (variables, PATH, etc.)
;; Esencial si usás flakes con nix develop o nix shell
;; ============================================================
 
(use-package envrc
  :init
  (envrc-global-mode)) ;; Activa envrc en todos los buffers, respetando el directorio del proyecto






;; ============================================================
;; HELPFUL
;; Reemplaza el sistema de ayuda built-in con uno más claro.
;; C-h f → documentación de una función con ejemplos
;; C-h v → documentación de una variable
;; C-h k → qué hace un atajo de teclado
;; ============================================================

(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))


;; ============================================================
;; AVY
;; Navegación ultrarrápida a cualquier parte de la pantalla.
;; M-s → escribís 2 letras de la palabra destino → apretás
;;        la letra que aparece sobre ella → el cursor salta
;; ============================================================

(use-package avy
  :bind ("M-s" . avy-goto-char-2))


(use-package gptel
  :ensure t
  :config
  ;; Registrar y establecer GitHub Copilot como el backend por defecto
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))

  ;; Configurar el modelo predeterminado del chat
  (setq gptel-model 'gpt-4o))
