;;; facusmzi-modeline --- modeline -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; ─── Helper ────────────────────────────────────────────────
;; lcolonq define colonq/replace-home en colonq-utility.el
;; por ahora usamos abbreviate-file-name que hace lo mismo:
;; reemplaza el path del home con ~
;; cuando tengamos facusmzi-utility.el lo movemos ahí
(defun facusmzi/replace-home (dir)
  "Reemplaza el directorio home en DIR con ~."
  (if (file-remote-p dir)
      dir
    (abbreviate-file-name dir)))

;; ─── Render ────────────────────────────────────────────────
;; Toma dos strings y los alinea: LEFT a la izquierda, RIGHT a la derecha
(defun facusmzi/mode-line-render (left right)
  "Renderiza el modeline con LEFT y RIGHT alineados."
  (let* ((available-width (- (window-width) (length left) 3)))
    (format (format " %%s %%%ds " available-width) left right)))

;; ─── Formato ───────────────────────────────────────────────
(setq-default
 mode-line-format
 '((:eval
    (facusmzi/mode-line-render
     ;; Izquierda: nombre del buffer - modo - directorio
     (concat
      (propertize (format-mode-line (buffer-name)) 'face 'bold)
      " - "
      (format-mode-line mode-name)
      " - "
      (facusmzi/replace-home default-directory))
     ;; Derecha: línea y columna
     (format-mode-line
      '(line-number-mode
        (" line %l"
         (column-number-mode " column %c"))))))))

(provide 'facusmzi-modeline)
;;; facusmzi-modeline.el ends here
