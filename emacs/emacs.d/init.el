;; Pantalla completa en GNOME
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Redirigir custom-set-* a archivo separado para que no pise nada
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; UI básica
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 12)
(global-display-line-numbers-mode 1)
(column-number-mode)
(delete-selection-mode 1)

;; Sin archivos de backup molestos
(setq make-backup-files nil
      auto-save-default nil)

;; Números de línea más grandes
(custom-set-faces
  '(line-number ((t (:height 1.2)))))

;; Fuente
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 130)

;; Historial
(recentf-mode 1)
(global-set-key (kbd "C-c r") 'recentf-open-files)
(setq history-length 25)
(savehist-mode 1)

;; Desactivar números de línea en ciertos modos
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Nix instaló los paquetes — use-package solo configura
(require 'use-package)
(setq use-package-always-ensure nil)

;; Tema
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha
        catppuccin-highlight-line-numbers t
        catppuccin-italic-comments t
        catppuccin-italic-keywords t)
  (load-theme 'catppuccin t))

;; Completion / navegación
(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package ivy-rich
  :after ivy
  :config (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  :bind (("M-x"     . counsel-M-x)
         ("C-x b"   . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history)))

(use-package helpful
  :after counsel
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

;; UI
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 15))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.5))

;; Proyectos
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom (projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '(("~/projects/" . 2)))))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode 1))

;; Git
(use-package magit
  :custom
  (magit-display-buffer-function
   #'magit-display-buffer-same-window-except-diff-v1))

;; Org
(use-package org
  :hook (org-mode . org-indent-mode))

(use-package org-modern
  :after org
  :hook (org-mode . org-modern-mode))
