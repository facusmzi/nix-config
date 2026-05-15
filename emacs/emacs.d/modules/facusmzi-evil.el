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
  (define-key evil-normal-state-map (kbd "\"") #'evil-window-vsplit)
  (define-key evil-normal-state-map (kbd "%") #'evil-window-split)

  (global-set-key (kbd "M-h") #'windmove-left)
  (global-set-key (kbd "M-l") #'windmove-right)
  (global-set-key (kbd "M-k") #'windmove-up)
  (global-set-key (kbd "M-j") #'windmove-down))

(provide 'facusmzi-evil)
;;; mu-evil.el ends here
