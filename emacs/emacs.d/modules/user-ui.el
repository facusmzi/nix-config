;;; user-ui.el --- UI básica y apariencia -*- lexical-binding: t -*-

;;; UI Básica
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(let ((opacity 100))
  (set-frame-parameter nil 'alpha-background opacity)
  (add-to-list 'default-frame-alist `(alpha-background . ,opacity)))

(setq inhibit-startup-message t
      use-short-answers t
      frame-resize-pixelwise t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 12)
(column-number-mode)
(delete-selection-mode 1)
(electric-pair-mode 1)
(save-place-mode)
(global-display-line-numbers-mode 1)
(blink-cursor-mode -1)
(setq-default cursor-in-non-selected-windows nil)

(setq scroll-conservatively 101
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t)

(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
		eat-mode-hook 
                pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-set-key (kbd "C-w") #'kill-region)

;;; Fuente
(set-face-attribute 'default nil
                    :font "FiraCode Nerd Font"
                    :height 130
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil
                    :font "Roboto"
                    :height 130
                    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
                    :font "FiraCode Nerd Font"
                    :height 130
                    :weight 'medium)
(set-language-environment "UTF-8")
(setq-default line-spacing 0)

;;; Paleta Catppuccin Mocha
(setq user/bg-0    "#11111B"   ; crust — fondo más oscuro
      user/bg-1    "#181825"   ; mantle — fondo principal
      user/bg-2    "#1e1e2e"   ; base — fondo más claro
      user/acc-0   "#CBA6F7"   ; mauve — acento principal
      user/acc-1   "#89B4FA"   ; blue — acento secundario
      user/acc-2   "#cdd6f4")  ; text

(add-hook 'after-init-hook
          (lambda ()
            (set-face-attribute 'default nil :background user/bg-1)
            (set-face-attribute 'fringe nil :background user/bg-1)
            (set-face-attribute 'line-number nil :background user/bg-1)
            (set-face-attribute 'line-number-current-line nil
                                :background user/bg-1
                                :foreground user/acc-0)
            (set-face-attribute 'mode-line nil :background user/bg-0)
            (set-face-attribute 'mode-line-inactive nil :background user/bg-0)
            (set-face-attribute 'vertical-border nil
                                :background user/bg-0
                                :foreground user/bg-0)))

(add-hook 'minibuffer-setup-hook
          (lambda ()
            (face-remap-add-relative 'default `(:background ,user/bg-0))
            (face-remap-add-relative 'fringe  `(:background ,user/bg-0 :foreground ,user/bg-0))))

;;; Tema
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)
  (doom-themes-org-config))

;;; Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (display-battery-mode 1)
  (display-time-mode 1)

  :custom
  (display-time-default-load-average nil))

;;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; GC post-startup
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 16)
                  gc-cons-percentage 0.1)
            (setq file-name-handler-alist file-name-handler-alist-original)
            (makunbound 'file-name-handler-alist-original)))

(provide 'user-ui)
;;; user-ui.el ends here
