;;; mu-evil.el --- modal editing -*- lexical-binding: t; -*-

(use-package undo-tree
  :custom
  (undo-tree-auto-save-history nil)
  :config
  (global-undo-tree-mode))

(use-package evil
  :custom
  (evil-undo-system 'undo-tree)
  (evil-want-minibuffer t)
  (evil-auto-balance-windows nil)
  :config
  (evil-mode)

  (define-key evil-normal-state-map (kbd "q") 'mu/open-dispatcher)
  (define-key evil-motion-state-map (kbd "q") 'mu/open-dispatcher)
  (define-key evil-emacs-state-map (kbd "q") 'mu/open-dispatcher)

  (define-key evil-normal-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "0") 'evil-first-non-blank)

  (define-key evil-normal-state-map (kbd "C-z") nil)
  (define-key evil-insert-state-map (kbd "C-z") nil)
  (define-key evil-motion-state-map (kbd "C-z") nil)

  (define-key evil-normal-state-map (kbd "#") #'comment-dwim)
  (define-key evil-visual-state-map (kbd "#") #'comment-dwim)

  ;; Ventanas
  (define-key evil-normal-state-map (kbd "\"") (lambda () (interactive) (evil-window-vsplit) (windmove-right)))
  (define-key evil-normal-state-map (kbd "%") (lambda () (interactive) (evil-window-split) (windmove-down)))

  ;; Windmove con bind-key* para que ningún modo mayor los pise
  (bind-key* "M-h" #'windmove-left)
  (bind-key* "M-l" #'windmove-right)
  (bind-key* "M-k" #'windmove-up)
  (bind-key* "M-j" #'windmove-down)

  ;; Escape inteligente
  (defun mu/escape ()
    "Escapar según el contexto."
    (interactive)
    (cond
     ((evil-insert-state-p)  (evil-normal-state))
     ((evil-visual-state-p)  (evil-exit-visual-state))
     ((evil-replace-state-p) (evil-normal-state))
     (t (keyboard-quit))))

  (global-set-key (kbd "<f12>") #'mu/escape)
  (define-key evil-insert-state-map  (kbd "<f12>") #'mu/escape)
  (define-key evil-visual-state-map  (kbd "<f12>") #'mu/escape)
  (define-key evil-normal-state-map  (kbd "<f12>") #'mu/escape)
  (define-key evil-motion-state-map  (kbd "<f12>") #'mu/escape))

(provide 'facusmzi-evil)
;;; mu-evil.el ends here
