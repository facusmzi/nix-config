;;; init.el -*- lexical-binding: t; -*-

;; ============================================================
;; STARTUP
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
(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)
(setq scroll-step 1)


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
(setq recentf-max-saved-items nil)


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
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-minibuffer t)
  (evil-undo-system 'undo-tree)
  (evil-auto-balance-windows nil)
  :config
  (evil-mode 1)

  (evil-set-initial-state 'magit-status-mode  'motion)
  (evil-set-initial-state 'magit-diff-mode    'motion)
  (evil-set-initial-state 'magit-stashes-mode 'motion)
  (evil-set-initial-state 'compilation-mode   'motion)
  (evil-set-initial-state 'special-mode       'motion)
  (evil-set-initial-state 'Info-mode          'motion)

  (define-key evil-normal-state-map (kbd "m") 'evil-record-macro)

  (define-key evil-normal-state-map (kbd ":") nil)
  (define-key evil-motion-state-map (kbd ":") nil)
  (define-key evil-visual-state-map (kbd ":") nil)

  (define-key evil-normal-state-map (kbd "#") #'comment-dwim)
  (define-key evil-visual-state-map (kbd "#") #'comment-dwim)

  (define-key evil-normal-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "0") 'evil-first-non-blank))


;; ============================================================
;; ESCAPE UNIVERSAL
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
    (abort-minibuffers))
   ((and (bound-and-true-p corfu-mode) corfu--candidates)
    (corfu-quit))
   ((or (evil-insert-state-p) (evil-replace-state-p))
    (evil-normal-state))
   ((evil-visual-state-p)
    (evil-exit-visual-state))
   (t
    (keyboard-quit))))

(global-set-key (kbd "<escape>") #'my/escape)

;; Minibuffers sin vertico (read-passwd, etc.)
(with-eval-after-load 'evil
  (dolist (map (list minibuffer-local-map
                     minibuffer-local-ns-map
                     minibuffer-local-completion-map
                     minibuffer-local-must-match-map
                     minibuffer-local-filename-completion-map))
    (evil-define-key 'insert map
      (kbd "<escape>") #'my/escape)))


;; ============================================================
;; EVIL-COLLECTION
;; ============================================================

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; ============================================================
;; DIRED
;; ============================================================

(use-package dired
  :custom
  (dired-dwim-target t)
  (dired-listing-switches "-lvah")
  :config
  (defun my/dired-find-file ()
    "Abre directorio sin crear un nuevo buffer."
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
;; MOVIMIENTO ENTRE VENTANAS
;; ============================================================

(global-set-key (kbd "M-h") #'windmove-left)
(global-set-key (kbd "M-l") #'windmove-right)
(global-set-key (kbd "M-k") #'windmove-up)
(global-set-key (kbd "M-j") #'windmove-down)


;; ============================================================
;; HYDRA + DISPATCHER EN "q"
;; ============================================================

(use-package hydra)

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
  ("f" my/format-buffer)
  ("q" my/dispatcher/body)
  ("<escape>" nil))

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
  ("f" find-file)
  ("r" consult-recent-file)
  ("s" save-buffer)
  ("b" consult-buffer)
  ("k" kill-current-buffer)
  ("q" (switch-to-buffer (other-buffer)))
  ("/" consult-ripgrep)
  ("l" consult-line)
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("w" delete-window)
  ("+" (text-scale-increase 1) :color red)
  ("=" (text-scale-increase 1) :color red)
  ("-" (text-scale-increase -1) :color red)
  ("g" my/vc-dispatcher/body)
  ("i" my/lsp-dispatcher/body)
  ("hf" helpful-callable)
  ("hv" helpful-variable)
  ("hk" helpful-key)
  ("<escape>" nil))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "q") 'my/dispatcher/body)
  (define-key evil-motion-state-map (kbd "q") 'my/dispatcher/body)
  (define-key evil-emacs-state-map  (kbd "q") 'my/dispatcher/body))


;; ============================================================
;; STACK DE COMPLETION MODERNO
;; ============================================================

(use-package vertico
  :init (vertico-mode)
  :config
  ;; vertico usa use-local-map y reemplaza el keymap local del minibuffer,
  ;; dejando los keymaps de evil sin efecto. evil-normalize-keymaps los
  ;; reactiva después de cada setup de vertico.
  (advice-add 'vertico--setup :after #'evil-normalize-keymaps)
  (evil-define-key 'insert vertico-map
    (kbd "<escape>") #'my/escape))

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
;; ============================================================

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  :init (global-corfu-mode))


;; ============================================================
;; EGLOT (LSP)
;; ============================================================

(use-package eglot
  :hook
  ((haskell-mode . eglot-ensure)
   (nix-mode     . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd"))))

;; ============================================================
;; HASKELL-MODE
;; ============================================================

(use-package haskell-mode)


;; ============================================================
;; FORMATEO POR MODO
;; ============================================================

(defun my/alejandra-format-buffer ()
  "Formatea el buffer actual con alejandra (para nix-mode)."
  (let ((pos (point)))
    (shell-command-on-region
     (point-min) (point-max)
     "alejandra --quiet -"
     nil t "*alejandra-errors*")
    (goto-char (min pos (point-max)))))

(defun my/format-buffer ()
  "Formatea: alejandra para nix, eglot-format para el resto."
  (interactive)
  (cond
   ((derived-mode-p 'nix-mode) (my/alejandra-format-buffer))
   ((bound-and-true-p eglot--managed-mode) (eglot-format))
   (t (message "No hay formateador disponible"))))

(add-hook 'nix-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/alejandra-format-buffer nil t)))


;; ============================================================
;; FLYMAKE
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
;; ============================================================

(use-package wgrep)


;; ============================================================
;; MAGIT
;; ============================================================

(use-package magit
  :custom
  (magit-no-message '("Turning on"))
  :bind ("C-x g" . magit-status)
  :config
  (evil-define-key 'motion magit-mode-map
    (kbd "q") 'my/dispatcher/body)
  (evil-define-key 'normal magit-mode-map
    (kbd "q") 'my/dispatcher/body))


;; ============================================================
;; ENVRC
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
;; RESTAURAR GC
;; ============================================================

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist my/file-name-handler-alist)
