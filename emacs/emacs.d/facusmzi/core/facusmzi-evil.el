;;; facusmzi-evil --- modal editing -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(use-package undo-tree
  :custom
  ;; No guardar historial de undo en disco, solo en memoria
  (undo-tree-auto-save-history nil)
  :config
  (global-undo-tree-mode))

(use-package evil
  :custom
  ;; No rebalancear ventanas al abrir/cerrar splits
  (evil-auto-balance-windows nil)
  ;; No expandir abbrevs al salir de insert mode
  (evil-want-abbrev-expand-on-insert-exit nil)
  ;; Permitir evil en el minibuffer
  (evil-want-minibuffer t)
  ;; Usar undo-tree como sistema de undo
  (evil-undo-system 'undo-tree)
  :config
  (evil-mode)

  ;; Estados iniciales por modo — igual que lcolonq
  ;; motion: podés moverte pero no editar (bueno para buffers de solo lectura)
  (setq evil-emacs-state-modes '())
  (evil-set-initial-state 'image-mode 'motion)
  (evil-set-initial-state 'special-mode 'motion)
  (evil-set-initial-state 'compilation-mode 'motion)
  (evil-set-initial-state 'grep-mode 'motion)
  (evil-set-initial-state 'Info-mode 'motion)
  (evil-set-initial-state 'magit-status-mode 'motion)
  (evil-set-initial-state 'magit-diff-mode 'motion)

  ;; Shells en normal para poder navegar el output
  (evil-set-initial-state 'eshell-mode 'normal)
  (evil-set-initial-state 'term-mode 'normal)

  ;; Que 0 vaya al primer caracter no-espacio en vez del inicio de línea
  (define-key evil-normal-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "0") 'evil-first-non-blank)

  ;; Comentar con # en normal y visual (más cómodo que gc)
  (define-key evil-normal-state-map (kbd "#") #'comment-dwim)
  (define-key evil-visual-state-map (kbd "#") #'comment-dwim)

  ;; Pegar desde el clipboard en prompts de contraseña
  (define-key read-passwd-map (kbd "C-v") 'evil-paste-after)

  ;; TODO: cuando tengamos el dispatcher, atar q a facusmzi/dispatcher
  ;; (define-key evil-normal-state-map (kbd "q") 'facusmzi/dispatcher)
  ;; (define-key evil-motion-state-map (kbd "q") 'facusmzi/dispatcher)
  )

(provide 'facusmzi-evil)
;;; facusmzi-evil.el ends here
