;;; facusmzi-dispatcher --- contextual interfaces -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-evil)
(require 'facusmzi-hydra)

;; ─── Sistema de contexto ───────────────────────────────────
;; Variables buffer-local que cada modo puede sobreescribir
;; para personalizar el comportamiento del dispatcher
(defvar-local facusmzi/contextual-ide
  (lambda () (interactive) (message "No IDE en este modo")))
(defvar-local facusmzi/contextual-lookup 'man)
(defvar-local facusmzi/contextual-quit nil)
(defvar-local facusmzi/contextual-write nil)
(defvar-local facusmzi/contextual-kill nil)

;; El lookup lo usa evil-K por defecto
(setq evil-lookup-func (lambda () (call-interactively facusmzi/contextual-lookup)))

;; ─── Integración con evil ──────────────────────────────────
;; evil-quit y evil-write revisan si hay función contextual primero
(defun facusmzi/evil-quit-wrapper (f &rest args)
  "Wrapper sobre F (evil-quit), pasando ARGS."
  (if facusmzi/contextual-quit
      (call-interactively facusmzi/contextual-quit)
    (apply f args)))
(advice-add 'evil-quit :around 'facusmzi/evil-quit-wrapper)

(defun facusmzi/evil-write-wrapper (f &rest args)
  "Wrapper sobre F (evil-write), pasando ARGS."
  (if facusmzi/contextual-write
      (call-interactively facusmzi/contextual-write)
    (apply f args)))
(advice-add 'evil-write :around 'facusmzi/evil-write-wrapper)

;; ─── Utilidades ────────────────────────────────────────────
(defun facusmzi/kill-this-buffer ()
  "Cerrar buffer actual o llamar a contextual-kill."
  (interactive)
  (if facusmzi/contextual-kill
      (call-interactively facusmzi/contextual-kill)
    (kill-this-buffer)))

(defun facusmzi/switch-to-scratch ()
  "Ir al buffer scratch, creándolo en eshell-mode si no existe."
  (interactive)
  (if (get-buffer "*scratch*")
      (switch-to-buffer "*scratch*")
    (progn
      (switch-to-buffer (get-buffer-create "*scratch*"))
      (cd "~")
      (eshell-mode))))

;; ─── Sub-dispatchers ───────────────────────────────────────
(defhydra facusmzi/repl-dispatcher (:color teal :hint nil)
  "Dispatcher > REPLs"
  ("<f12>" keyboard-escape-quit "salir")
  ("l" ielm "elisp"))
  ;; TODO: agregar cuando tengamos los módulos
  ;; ("x" nix-repl "nix")
  ;; ("y" (switch-to-buffer (make-comint "Python REPL" "python3" nil)) "python")

;; ─── Dispatcher principal ──────────────────────────────────
(defhydra facusmzi/dispatcher (:color teal :hint nil)
  "Dispatcher"
  ("<f12>" keyboard-escape-quit)

  ;; Ventanas y buffers
  ("SPC" facusmzi/kill-this-buffer)
  ("\"" evil-window-vsplit)
  ("%" evil-window-split)
  ("0" facusmzi/switch-to-scratch)

  ;; Zoom de texto (:color red = no cerrar el hydra al ejecutar)
  ("+" (text-scale-increase 1) :color red)
  ("=" (text-scale-increase 1) :color red)
  ("-" (text-scale-increase -1) :color red)

  ;; IDE contextual — cada modo setea facusmzi/contextual-ide
  ("i" (call-interactively facusmzi/contextual-ide) "ide")

  ;; REPLs
  ("h" facusmzi/repl-dispatcher/body "repl")
  ("H" ielm)

  ;; Write/quit
  ("w" evil-write)
  ("k" evil-quit)

  ;; TODO: descomentar cuando tengamos los módulos
  ;; ("f" selector-for-files "archivo")
  ;; ("o" facusmzi/navigate "buf")
  ;; ("O" selector-for-buffers)
  ;; ("p" projectile-switch-project "proyecto")
  ;; ("s" facusmzi/shell-here "shell")
  ;; ("t" facusmzi/term-here "term")
  ;; ("v" facusmzi/vc-dispatcher/body "vc")
  ;; ("V" magit-status)
  ;; ("/" facusmzi/selector-rg)
  ;; (":" selector-M-x)
  ("q" facusmzi/previous-buffer)
  ;; ("B" facusmzi/visit-bookmark)

  ("?" describe-key "ayuda"))

;; ─── Entry points ──────────────────────────────────────────
(defun facusmzi/dispatcher ()
  "Abrir el dispatcher."
  (interactive)
  (let ((hydra-is-helpful nil))
    (call-interactively 'facusmzi/dispatcher/body)))

(defun facusmzi/dispatcher-silent ()
  "Abrir el dispatcher sin hint."
  (interactive)
  (let ((hydra-is-helpful nil))
    (call-interactively 'facusmzi/dispatcher/body)))

(provide 'facusmzi-dispatcher)
;;; facusmzi-dispatcher.el ends here
