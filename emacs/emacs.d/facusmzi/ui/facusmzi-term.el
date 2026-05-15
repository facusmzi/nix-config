;;; facusmzi-term --- terminal emulation -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

(use-package vterm
  :config
  ;; Sin excepciones — vterm captura todo en insert state
  (setq vterm-keymap-exceptions nil)

  ;; Matar el buffer cuando el proceso termina
  (defun facusmzi/maybe-kill-vterm (n e)
    (ignore e)
    (when n (kill-buffer)))
  (add-hook 'vterm-exit-functions #'facusmzi/maybe-kill-vterm)

  (define-key vterm-mode-map [return] #'vterm-send-return)
  (define-key vterm-mode-map [insert] #'evil-exit-emacs-state)

  ;; Insert state — pasar la mayoría de teclas directo a vterm
  (evil-define-key 'insert vterm-mode-map
    (kbd "<f12>")    #'evil-normal-state
    (kbd "<escape>") #'vterm--self-insert
    (kbd "C-e")      #'vterm--self-insert
    (kbd "C-f")      #'vterm--self-insert
    (kbd "C-a")      #'vterm--self-insert
    (kbd "C-v")      #'vterm--self-insert
    (kbd "C-b")      #'vterm--self-insert
    (kbd "C-w")      #'vterm--self-insert
    (kbd "C-u")      #'vterm--self-insert
    (kbd "C-d")      #'vterm--self-insert
    (kbd "C-n")      #'vterm--self-insert
    (kbd "C-m")      #'vterm--self-insert
    (kbd "C-p")      #'vterm--self-insert
    (kbd "C-j")      #'vterm--self-insert
    (kbd "C-k")      #'vterm--self-insert
    (kbd "C-r")      #'vterm--self-insert
    (kbd "C-t")      #'vterm--self-insert
    (kbd "C-g")      #'vterm--self-insert
    (kbd "C-c")      #'vterm--self-insert
    (kbd "C-SPC")    #'vterm--self-insert)

  ;; Normal state — navegación y acceso al dispatcher
  (evil-define-key 'normal vterm-mode-map
    (kbd "C-d")      #'vterm--self-insert
    (kbd "p")        #'vterm-yank
    (kbd "u")        #'vterm-undo
    (kbd "<insert>") #'evil-emacs-state
    (kbd "<return>") #'evil-resume))

(defun facusmzi/term-here ()
  "Abrir vterm en el directorio actual."
  (interactive)
  (vterm))

(provide 'facusmzi-term)
;;; facusmzi-term.el ends here
