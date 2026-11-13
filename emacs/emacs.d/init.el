;;; init.el --- configuración personal -*- lexical-binding: t; -*-

;; ============================================================
;; STARTUP
;; ============================================================

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)


;; ============================================================
;; INTERCAMBIO CTRL <-> META (solo dentro de Emacs)
;; ============================================================
;; Alt físico + tecla  -> C-tecla
;; Ctrl físico + tecla -> M-tecla
;; Fuera de Emacs el teclado queda igual.
;; Esc sigue sirviendo como Meta: Esc x = M-x.

(defun mi/swap-ctrl-meta (base)
  "Intercambia C-BASE y M-BASE en `key-translation-map'."
  (let ((c (event-convert-list (list 'control base)))
        (m (event-convert-list (list 'meta base))))
    (define-key key-translation-map (vector c) (vector m))
    (define-key key-translation-map (vector m) (vector c))))

;; 1. Casi todas las teclas: intercambio directo.
;;    i y m van aparte (paso 2). [ y Retroceso se dejan como están (abajo).
(dolist (base (append
               (seq-remove (lambda (ch) (memq ch '(?i ?m ?\[)))
                           (number-sequence ?! ?~))
               '(?\s left right up down home end prior next delete)))
  (mi/swap-ctrl-meta base))

;; 2. i y m.
;;    Para Emacs, C-i es lo mismo que Tab y C-m lo mismo que Enter
;;    (herencia del ASCII). En el Emacs gráfico se pueden separar:
;;    input-decode-map convierte Ctrl+i y Ctrl+m físicos en teclas propias,
;;    <C-i> y <C-m>, sin tocar las teclas Tab y Enter.
(define-key input-decode-map [?\C-i] [C-i])
(define-key input-decode-map [?\C-m] [C-m])
;;    Ctrl+i / Ctrl+m físicos -> M-i / M-m (siguen la regla Ctrl = M-)
(define-key key-translation-map [C-i] (kbd "M-i"))
(define-key key-translation-map [C-m] (kbd "M-m"))
;;    Alt+i / Alt+m físicos -> C-i / C-m (siguen la regla Alt = C-),
;;    o sea, actúan como Tab y Enter, igual que C-i y C-m en cualquier Emacs.
(define-key key-translation-map (kbd "M-i") (kbd "C-i"))
(define-key key-translation-map (kbd "M-m") (kbd "C-m"))

;; 3. Ctrl+x físico tiene que dar M-x al instante.
;;    `function-key-map' trae el prefijo C-x @ (C-x @ h, C-x @ s…, para
;;    aplicar modificadores en terminales sin esas teclas). Como C-x es un
;;    prefijo ahí, Emacs se quedaba esperando otra tecla antes de aplicar el
;;    intercambio, y mientras tanto which-key mostraba el popup de C-x.
;;    Sacar ese prefijo hace que Ctrl+x se traduzca a M-x apenas se aprieta.
(define-key function-key-map [?\C-x] nil t)

;; Lo que queda sin intercambiar, a propósito:
;;    - [ : en teclado latam/español se escribe con AltGr, así que Ctrl+[ y
;;      Alt+[ casi no se pueden apretar. Además C-[ es Esc, que usamos como Meta.
;;    - Retroceso: Alt+Retroceso y Ctrl+Retroceso ya borran la palabra
;;      anterior; intercambiarlos no cambia nada y los rompe.


;; ============================================================
;; INTERFAZ MÍNIMA
;; ============================================================

(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Fuente: Fira Code (nerd-fonts.fira-code en emacs/default.nix).
;; Va en default-frame-alist para que también aplique a frames de emacsclient.
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-12"))
(menu-bar-mode -1)
(tool-bar-mode -1)
(save-place-mode 1)
(show-paren-mode 1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(tooltip-mode -1)
(setq-default cursor-in-non-selected-windows nil
	      bidi-display-reordering nil)
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      sentence-end-double-space nil
      custom-file "/dev/null"
      confirm-kill-emacs 'y-or-n-p)


;; ============================================================
;; COMPORTAMIENTO DEL EDITOR
;; ============================================================

(electric-pair-mode 1)
(global-auto-revert-mode 1)
(setq use-short-answers t)
(delete-selection-mode 1)
(setq scroll-step 1)

;; Desplazamiento suave con la rueda del mouse (píxel a píxel).
;; Por defecto la rueda solo se anima si el salto supera
;; `pixel-scroll-precision-large-scroll-height', que vale nil, así que
;; cada paso salta de golpe. Con 1.0 se anima siempre.
;; 3 líneas por paso y sin acelerar al girar rápido, parecido a VS Code.
;; Más suave: subir total-time. Más rápido: bajarlo.
(pixel-scroll-precision-mode 1)
(setq pixel-scroll-precision-large-scroll-height 1.0
      pixel-scroll-precision-interpolation-total-time 0.3
      mouse-wheel-scroll-amount '(3 ((shift) . hscroll))
      mouse-wheel-progressive-speed nil)

;; Al borrar un archivo no lo borra directamente: lo manda a la papelera.
(setq delete-by-moving-to-trash t)


;; ============================================================
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; ============================================================
;; NÚMEROS DE LÍNEA Y COLUMNA
;; ============================================================

(defvar my/disable-line-numbers-modes
  '(pdf-view-mode term-mode shell-mode eshell-mode vterm-mode )
  "Modos donde no quiero `display-line-numbers-mode' activo.")

(defun my/maybe-disable-line-numbers ()
  (when (apply #'derived-mode-p my/disable-line-numbers-modes)
    (display-line-numbers-mode -1)))

(add-hook 'after-change-major-mode-hook #'my/maybe-disable-line-numbers t)



;; ============================================================
;; HISTORIAL Y ARCHIVOS RECIENTES
;; ============================================================

(savehist-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items nil)


;; ============================================================
;; BACKUPS
;; ============================================================

(setq make-backup-files nil
      auto-save-default nil)
(setq create-lockfiles nil)

;; ;; ============================================================
;; ;; TEMA
;; ;; ============================================================

(use-package dracula-theme
  :config
  (load-theme 'dracula t))


;; ;; ============================================================
;; ;; WHICH-KEY
;; ;; ============================================================

(use-package which-key
  :config
  (which-key-mode))




;; ============================================================
;; COMPLETION
;; ============================================================

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

;; C-s (Alt+s con el intercambio) busca dentro del buffer con consult-line.
(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("C-c r" . consult-recent-file)))


;; C-x C-d (Alt+x Alt+d con el intercambio): global y dentro del minibuffer,
;; para saltar de carpeta en medio de un find-file.
(use-package consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-completion-map
   ("C-x C-d" . consult-dir))
  :config
  (setq consult-dir-sources
	'((:name "Dirs"
		 :narrow ?d
		 :category file
		 :face consult-file
		 :items (lambda ()
			  '("~/nix-config/"
			    "~/Documentos/projects/"
			    "~/Documentos/org/"))))))


;; ============================================================
;; EDICIÓN
;; ============================================================

;; move-text: subir/bajar la línea o la región con M-↑ / M-↓
;; (Ctrl+↑ / Ctrl+↓ con el intercambio). En org mandan las teclas de org.
(use-package move-text
  :config
  (move-text-default-bindings))

;; rainbow-delimiters: colorea cada nivel de paréntesis distinto.
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; imenu: índice de headings de org (Ctrl+i con el intercambio)
(global-set-key (kbd "M-i") #'imenu)


;; ============================================================
;; MAGIT
;; ============================================================

(use-package magit)




;; ;; ============================================================
;; ;; ENVRC
;; ;; ============================================================

(use-package envrc
  :init
  (envrc-global-mode))



;; ;; ============================================================
;; ;; NIX-MODE
;; ;; ============================================================

(use-package nix-mode
  :mode "\\.nix\\'")


;; ============================================================
;; MARKDOWN
;; ============================================================
;; Preview: C-c C-c l (Alt+c Alt+c l) en una ventana al lado con eww,
;;          C-c C-c p (Alt+c Alt+c p) en el navegador.

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :custom
  (markdown-command "pandoc"))





;; ============================================================
;; CORFU
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode)
  :config
  ;; orderless para completion de lsp
  (defun my/lsp-completion-setup ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
	  '(orderless)))
  (add-hook 'lsp-completion-mode-hook #'my/lsp-completion-setup))

;; cape-file: completa rutas de archivos con corfu en cualquier buffer.
;; En los buffers con lsp corre después de la completion de lsp.
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file))



;; ============================================================
;; TREESITTER
;; ============================================================

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
	))


;; ============================================================
;; LSP-MODE
;; ============================================================

;; lsp recibe respuestas grandes del servidor: leer de a 1 MB en vez de 64 KB.
(setq read-process-output-max (* 1024 1024))

;; yasnippet: lsp-mode lo usa para los snippets que propone el servidor
;; (argumentos de funciones, etc.).
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-idle-delay 0.3)
  (lsp-log-io nil)
  (lsp-completion-provider :none)  
  (lsp-headerline-breadcrumb-enable nil)
  :hook
  ((python-ts-mode . lsp-deferred)
   (haskell-mode   . lsp-deferred)
   (nix-mode       . lsp-deferred)   
   (lsp-mode       . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t))





;; ============================================================
;; NIX LSP (nixd)
;; ============================================================

(with-eval-after-load 'lsp-mode
  (setq lsp-nix-nixd-server-path "nixd"
	lsp-nix-nixd-formatting-command ["nixfmt"]
	lsp-nix-nixd-nixpkgs-expr "import <nixpkgs> {}"))



;; ============================================================
;; HASKELL
;; ============================================================

(use-package haskell-mode
  :hook
  (haskell-mode . interactive-haskell-mode))

(use-package lsp-haskell
  :after lsp-mode
  :custom
  (lsp-haskell-server-path "haskell-language-server-wrapper"))





;; ============================================================
;; ORG-BABEL CSHARP
;; ============================================================

(let* ((dotnet-bin
	(string-trim
	 (shell-command-to-string "readlink -f $(which dotnet)")))
       (dotnet-root
	(directory-file-name
	 (file-name-directory dotnet-bin))))
  (setenv "DOTNET_ROOT" dotnet-root))


;; ob-csharp viene incluido en Emacs 31 (org 9.8); lo carga
;; org-babel-do-load-languages.
(use-package org
  :config
  (setq org-babel-csharp-default-target-framework "net10.0")

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (csharp . t)))

  (setq org-confirm-babel-evaluate nil)



  ;; ============================================================
  ;; LaTeX previews (FIX dvipng → dvisvgm)
  ;; ============================================================

  (setq org-startup-with-latex-preview t)
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-latex-create-formula-image-program 'dvisvgm)

  ;; Símbolos de lógica: Fira Code no tiene ∼ ⇒ ⇔ ⊻, se toman de DejaVu.
  (set-fontset-font t '(#x2190 . #x21FF) "DejaVu Sans Mono")   ; flechas ⇒ ⇔
  (set-fontset-font t '(#x2200 . #x22FF) "DejaVu Sans Mono")   ; ∼ ∧ ∨
  (set-fontset-font t ?⊻ "DejaVu Math TeX Gyre")

  ;; valign: alinea las tablas por píxel. Sin esto, esos símbolos (y los
  ;; emojis) salen de otra fuente con otro ancho y las columnas se corren.
  (setq valign-fancy-bar t)
  (add-hook 'org-mode-hook #'valign-mode))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  (pdf-loader-install)
  :custom
  (pdf-view-midnight-colors '("#f8f8f2" . "#282a36")) ;; texto . fondo, paleta Dracula
  :hook
  (pdf-view-mode . pdf-view-midnight-minor-mode))






;; ============================================================
;; VTERM
;; ============================================================

;; C-c t (Alt+c t con el intercambio): abre vterm en una ventana a la
;; derecha y le pasa el foco. Si ya está visible, va a esa ventana.
(add-to-list 'display-buffer-alist
	     '("\\`\\*vterm"
	       (display-buffer-reuse-window display-buffer-in-direction)
	       (direction . right)
	       (window-width . 0.5)))

(use-package vterm
  :commands vterm
  :bind ("C-c t" . vterm)
  :custom
  (vterm-shell (getenv "SHELL"))
  (vterm-max-scrollback 10000))



;; ============================================================
;; RESTAURAR GC
;; ============================================================

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist my/file-name-handler-alist)
