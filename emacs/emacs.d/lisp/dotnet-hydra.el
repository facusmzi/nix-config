;;; dotnet-hydra.el --- Hydra de herramientas .NET para csharp-mode -*- lexical-binding: t; -*-

;;; Commentary:
;; Menú hydra de herramientas .NET accesible con `q i a` en csharp-mode.
;; Requiere: hydra, general, evil, dotnet-tools.el (scaffolding), vterm.

;;; Code:

(require 'hydra)

;; ----------------------------
;; helpers internos
;; ----------------------------

(defun my/dotnet--run-in-vterm (cmd)
  "Ejecuta CMD en vterm, abriendo una nueva ventana debajo."
  (let ((default-directory (or (dotnet-tools--find-csproj-root) default-directory)))
    (split-window-below)
    (other-window 1)
    (vterm)
    ;; espera a que vterm esté listo y envía el comando
    (run-with-timer
     0.3 nil
     (lambda ()
       (vterm-send-string cmd)
       (vterm-send-return)))))

(defun my/dotnet-build ()
  "Ejecuta dotnet build en el root del proyecto."
  (interactive)
  (my/dotnet--run-in-vterm "dotnet build"))

(defun my/dotnet-test ()
  "Ejecuta dotnet test en el root del proyecto."
  (interactive)
  (my/dotnet--run-in-vterm "dotnet test"))

(defun my/dotnet-new-project ()
  "Crea un nuevo proyecto dotnet pidiendo tipo y nombre."
  (interactive)
  (let* ((type (completing-read
                "Tipo de proyecto: "
                '("webapi" "console" "classlib" "mvc" "blazorwasm" "worker")
                nil t))
         (name (read-string (format "Nombre del proyecto [%s]: " type)))
         (cmd  (if (string-empty-p name)
                   (format "dotnet new %s" type)
                 (format "dotnet new %s -n %s" type name))))
    (my/dotnet--run-in-vterm cmd)))

(defun my/dotnet-add-reference ()
  "Agrega una referencia a otro proyecto (.csproj) con dotnet add reference."
  (interactive)
  (let* ((root    (or (dotnet-tools--find-csproj-root) default-directory))
         (ref     (read-file-name "Referencia (.csproj): " root nil t nil
                                  (lambda (f)
                                    (or (file-directory-p f)
                                        (string-suffix-p ".csproj" f)))))
         (cmd     (format "dotnet add reference %s" (shell-quote-argument ref))))
    (my/dotnet--run-in-vterm cmd)))


;; ----------------------------
;; hydra principal
;; ----------------------------

(defhydra my/dotnet-hydra (:color teal :hint nil)
  "
╔═══════════════════════════════════════════╗
║           .NET Tools  (q i a)             ║
╠═══════════════════╦═══════════════════════╣
║  Scaffolding      ║  Proyecto             ║
║  _c_  clase       ║  _p_  nuevo proyecto  ║
║  _i_  interface   ║  _r_  add reference   ║
║  _o_  controller  ║  _b_  build           ║
║                   ║  _t_  test            ║
╠═══════════════════╩═══════════════════════╣
║  _q_  salir                               ║
╚═══════════════════════════════════════════╝
"
  ("c" dotnet-tools-create-class      "clase")
  ("i" dotnet-tools-create-interface  "interface")
  ("o" dotnet-tools-create-controller "controller")
  ("p" my/dotnet-new-project          "nuevo proyecto")
  ("r" my/dotnet-add-reference        "add reference")
  ("b" my/dotnet-build                "build")
  ("t" my/dotnet-test                 "test")
  ("q" nil                            "salir" :color blue))


;; ----------------------------
;; keybinding condicional
;; solo activo en csharp-mode
;; ----------------------------

(defun my/dotnet-setup-local-keybinding ()
  "Activa el keybinding `q i a` → dotnet hydra solo en este buffer."
  (general-define-key
   :states  '(normal visual)
   :keymaps 'local          ; <-- local al buffer, no global
   "q i a"  '(my/dotnet-hydra/body :which-key ".NET tools")))

(add-hook 'csharp-mode-hook #'my/dotnet-setup-local-keybinding)


(provide 'dotnet-hydra)
;;; dotnet-hydra.el ends here
