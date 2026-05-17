;;; user-windows.el --- Ace Window y Tab Bar -*- lexical-binding: t -*-

;; Salta a cualquier ventana visible asignándole una letra.
;; C-u M-o: swap de ventanas. C-u C-u M-o: mover buffer a otra ventana.
(use-package ace-window
  :bind
  ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-scope 'frame)
  :config
  (set-face-attribute 'aw-leading-char-face nil
                      :foreground user/acc-0
                      :height 2.5
                      :weight 'bold))

;; tab-bar-mode es built-in desde Emacs 27.
;; Cada tab mantiene su propio layout de ventanas y buffers.
(use-package tab-bar
  :ensure nil
  :init (tab-bar-mode 1)

  :custom
  (tab-bar-show 1)
  (tab-bar-new-tab-choice "*dashboard*")
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-name-function #'tab-bar-tab-name-current)

  :config
  (set-face-attribute 'tab-bar nil
                      :background user/bg-0
                      :foreground user/acc-2)
  (set-face-attribute 'tab-bar-tab nil
                      :background user/bg-2
                      :foreground user/acc-0
                      :weight 'bold)
  (set-face-attribute 'tab-bar-tab-inactive nil
                      :background user/bg-0
                      :foreground user/acc-2))

(provide 'user-windows)
;;; user-windows.el ends here
