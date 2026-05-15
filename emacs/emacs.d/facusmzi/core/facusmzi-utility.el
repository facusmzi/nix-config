;;; facusmzi-utility --- miscellaneous utility functions -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)

;; s, dash y f son librerías de utilidad muy usadas en la config de lcolonq
;; s  → manipulación de strings
;; dash → programación funcional con listas
;; f  → operaciones con archivos y paths
(use-package cl-lib)
(use-package s)
(use-package dash)
(use-package f)

;; ─── Home ──────────────────────────────────────────────────
(defvar facusmzi/home (getenv "HOME")
  "Path del directorio home.")

(defun facusmzi/replace-home (dir)
  "Reemplaza el directorio home en DIR con ~.
Si DIR es un path remoto lo devuelve sin modificar."
  (if (file-remote-p dir)
      dir
    (s-replace facusmzi/home "~" dir)))

;; ─── Buffers ───────────────────────────────────────────────
;; Patrones de buffers que no queremos ver en las listas de navegación
(defvar facusmzi/boring-buffer-regexp-list
  '("\\` "          ; buffers que empiezan con espacio (internos de emacs)
    "\\`\\*tramp"   ; buffers de conexiones remotas
    "\\`\\*Echo Area"
    "\\`\\*Minibuf"
    "\\`\\*eldoc"
    "*direnv*"
    "*Pinentry*"
    "*Shell Command Output*")
  "Lista de regexps de buffers aburridos.")

(defun facusmzi/buffer-boring-p (buffer)
  "Devuelve non-nil si BUFFER es aburrido (no queremos verlo en listas)."
  (cl-reduce
   (lambda (x y) (or x y))
   (mapcar (lambda (r) (string-match r buffer))
           facusmzi/boring-buffer-regexp-list)))

(defun facusmzi/buffer-eshell-p (buf)
  "Devuelve non-nil si BUF es un buffer de eshell."
  (member
   (buffer-local-value 'major-mode (get-buffer buf))
   '(eshell-mode)))

(defun facusmzi/buffer-list ()
  "Devuelve la lista de buffers no aburridos."
  (cl-remove-if 'facusmzi/buffer-boring-p
                (mapcar 'buffer-name (buffer-list))))

(defun facusmzi/unaffiliated-buffers ()
  "Devuelve buffers que no son shells ni están asociados a otras categorías."
  (cl-remove-if
   (lambda (b) (facusmzi/buffer-eshell-p b))
   (facusmzi/buffer-list)))

(defun facusmzi/buffer-directory (buf)
  "Devuelve el `default-directory' de BUF."
  (buffer-local-value 'default-directory (get-buffer buf)))

(defun facusmzi/previous-buffer ()
  "Ir al buffer anterior en la lista."
  (interactive)
  (switch-to-buffer (cadr (facusmzi/buffer-list))))

;; ─── Paths ─────────────────────────────────────────────────
(defun facusmzi/dirname (path)
  "Devuelve el nombre del directorio más interno de PATH.
Ejemplo: /home/facusmzi/nix-config → nix-config"
  (file-name-nondirectory
   (directory-file-name
    (file-name-directory path))))

;; ─── Mark ring ─────────────────────────────────────────────
;; lcolonq reemplaza el comportamiento default de C-u / C-o
;; para navegar el historial de posiciones de forma más predecible

(defun facusmzi/pop-mark ()
  "Sacar una posición del mark ring y ponerla como mark actual."
  (when mark-ring
    (set-marker (mark-marker) (car mark-ring))
    (set-marker (car mark-ring) nil)
    (unless (mark t) (ding))
    (pop mark-ring))
  (deactivate-mark))

(defun facusmzi/pop-to-mark-command ()
  "Saltar al mark y sacar una nueva posición del ring."
  (interactive)
  (if (null (mark t))
      (user-error "No hay mark en este buffer")
    (if (= (point) (mark t))
        (message "Mark popped"))
    (goto-char (mark t))
    (facusmzi/pop-mark)))

(defun facusmzi/unpop-to-mark-command ()
  "Ir hacia adelante en el mark ring (inverso de pop-to-mark)."
  (interactive)
  (when mark-ring
    (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
    (when (null (mark t)) (ding))
    (setq mark-ring (nbutlast mark-ring))
    (goto-char (marker-position (car (last mark-ring))))))

;; ─── Misc ──────────────────────────────────────────────────
(defun facusmzi/nop ()
  "No hacer nada. Útil para sobreescribir keybindings no deseados."
  (interactive)
  nil)

(provide 'facusmzi-utility)
;;; facusmzi-utility.el ends here
