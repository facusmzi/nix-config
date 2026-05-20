;;; dotnet-tools.el --- .NET scaffolding tools for Emacs -*- lexical-binding: t; -*-

;; Author: facusmzi
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: dotnet, csharp, scaffolding, tools
;; URL: https://github.com/facusmzi/dotnet-tools

;;; Commentary:

;; dotnet-tools.el provee comandos de scaffolding básicos para proyectos .NET,
;; similares a los de Visual Studio. Permite crear clases, interfaces y
;; controllers ASP.NET Core, recordando el directorio de trabajo.
;;
;; Uso:
;;   (require 'dotnet-tools)
;;   (dotnet-tools-hydra/body)  ; abre el menú principal
;;
;; O con use-package:
;;   (use-package dotnet-tools
;;     :load-path "~/.config/emacs/lisp/"
;;     :bind ("q d" . dotnet-tools-hydra/body))

;;; Code:

(require 'cl-lib)


;; ----------------------------
;; Estado interno
;; ----------------------------

(defgroup dotnet-tools nil
  "Scaffolding de proyectos .NET dentro de Emacs."
  :group 'tools
  :prefix "dotnet-tools-")

(defcustom dotnet-tools-default-directory nil
  "Directorio de trabajo por defecto para scaffolding .NET.
Se actualiza automáticamente al usar `dotnet-tools-set-directory'."
  :type '(choice (const nil) directory)
  :group 'dotnet-tools)

(defcustom dotnet-tools-auto-detect-root t
  "Si es non-nil, intenta detectar el root del proyecto .NET (donde está el .csproj)."
  :type 'boolean
  :group 'dotnet-tools)


;; ----------------------------
;; Detección de proyecto
;; ----------------------------

(defun dotnet-tools--find-csproj-root (&optional start-dir)
  "Busca el directorio raíz del proyecto .NET recorriendo hacia arriba desde START-DIR.
Devuelve el directorio que contiene un .csproj, o nil si no encuentra."
  (let ((dir (or start-dir default-directory)))
    (locate-dominating-file dir
                            (lambda (d)
                              (directory-files d nil "\\.csproj$" t)))))

(defun dotnet-tools--suggest-subdirectory (type root)
  "Sugiere un subdirectorio dentro de ROOT según el TYPE de archivo.
TYPE puede ser `class', `interface' o `controller'."
  (let ((subdir (pcase type
                  ('controller "Controllers")
                  ('interface  "Interfaces")
                  ('class      "Models")
                  (_           ""))))
    (let ((full (expand-file-name subdir root)))
      (if (file-directory-p full) full root))))

(defun dotnet-tools--detect-namespace (dir)
  "Intenta inferir el namespace C# a partir del nombre del directorio DIR."
  (let* ((root (dotnet-tools--find-csproj-root dir))
         (csproj (when root
                   (car (directory-files root nil "\\.csproj$" t))))
         (project-name (when csproj
                         (file-name-sans-extension csproj)))
         (rel (when (and root (string-prefix-p (expand-file-name root)
                                               (expand-file-name dir)))
                (file-relative-name (expand-file-name dir)
                                    (expand-file-name root))))
         (parts (when rel
                  (split-string (directory-file-name rel) "[/\\\\]" t))))
    (cond
     ((and project-name parts)
      (mapconcat #'identity (cons project-name parts) "."))
     (project-name project-name)
     (t (file-name-nondirectory (directory-file-name dir))))))


;; ----------------------------
;; Gestión de directorio
;; ----------------------------

(defun dotnet-tools--get-working-directory (type)
  "Obtiene el directorio de trabajo para TYPE.
Si `dotnet-tools-default-directory' no está seteado, pide uno al usuario.
Si `dotnet-tools-auto-detect-root' es t, sugiere la carpeta adecuada."
  (if (and dotnet-tools-default-directory
           (file-directory-p dotnet-tools-default-directory))
      ;; Ya hay un directorio guardado: ofrecer subdirectorio sugerido
      (if dotnet-tools-auto-detect-root
          (dotnet-tools--suggest-subdirectory type dotnet-tools-default-directory)
        dotnet-tools-default-directory)
    ;; Primera vez: detectar root o pedir
    (let* ((detected-root (when dotnet-tools-auto-detect-root
                            (dotnet-tools--find-csproj-root)))
           (initial (or detected-root default-directory))
           (chosen (read-directory-name
                    "Directorio raíz del proyecto .NET: "
                    initial nil t)))
      (setq dotnet-tools-default-directory chosen)
      (message "dotnet-tools: directorio guardado → %s" chosen)
      (if dotnet-tools-auto-detect-root
          (dotnet-tools--suggest-subdirectory type chosen)
        chosen))))

;;;###autoload
(defun dotnet-tools-set-directory ()
  "Cambia manualmente el directorio de trabajo por defecto para dotnet-tools."
  (interactive)
  (let* ((detected (when dotnet-tools-auto-detect-root
                     (dotnet-tools--find-csproj-root)))
         (initial (or dotnet-tools-default-directory detected default-directory))
         (chosen (read-directory-name
                  "Nuevo directorio .NET: "
                  initial nil t)))
    (setq dotnet-tools-default-directory chosen)
    (message "dotnet-tools: directorio actualizado → %s" chosen)))


;; ----------------------------
;; Templates C#
;; ----------------------------

(defun dotnet-tools--template-class (namespace name)
  "Genera el template de una clase C# con NAMESPACE y NAME."
  (format "namespace %s;

public class %s
{
    public %s()
    {
    }
}
" namespace name name))

(defun dotnet-tools--template-interface (namespace name)
  "Genera el template de una interface C# con NAMESPACE y NAME.
Agrega prefijo I si no lo tiene."
  (let ((iname (if (string-prefix-p "I" name) name (concat "I" name))))
    (format "namespace %s;

public interface %s
{
}
" namespace iname)))

(defun dotnet-tools--template-controller (namespace name)
  "Genera el template de un controller ASP.NET Core con NAMESPACE y NAME.
Agrega sufijo Controller si no lo tiene."
  (let* ((cname (if (string-suffix-p "Controller" name)
                    name
                  (concat name "Controller")))
         (route (downcase (string-remove-suffix "Controller" cname))))
    (format "using Microsoft.AspNetCore.Mvc;

namespace %s;

[ApiController]
[Route(\"api/[controller]\")]
public class %s : ControllerBase
{
    public %s()
    {
    }

    [HttpGet]
    public IActionResult Get()
    {
        return Ok();
    }
}
" namespace cname cname)))


;; ----------------------------
;; Creación de archivos
;; ----------------------------

(defun dotnet-tools--create-file (type)
  "Flujo principal de scaffolding para TYPE (`class', `interface' o `controller').
Determina directorio, pide nombre, genera template y abre el archivo."
  (let* ((dir      (dotnet-tools--get-working-directory type))
         (ns       (dotnet-tools--detect-namespace dir))
         (prompt   (pcase type
                     ('class      "Nombre de la clase: ")
                     ('interface  "Nombre de la interface (sin prefijo I): ")
                     ('controller "Nombre del controller (sin sufijo Controller): ")))
         (raw-name (read-string prompt))
         (name     (pcase type
                     ('class      raw-name)
                     ('interface  (if (string-prefix-p "I" raw-name)
                                      raw-name
                                    (concat "I" raw-name)))
                     ('controller (if (string-suffix-p "Controller" raw-name)
                                      raw-name
                                    (concat raw-name "Controller")))))
         (filename (expand-file-name (concat name ".cs") dir))
         (content  (pcase type
                     ('class      (dotnet-tools--template-class      ns raw-name))
                     ('interface  (dotnet-tools--template-interface   ns raw-name))
                     ('controller (dotnet-tools--template-controller  ns raw-name)))))
    ;; Crear directorio si no existe
    (unless (file-directory-p dir)
      (when (y-or-n-p (format "El directorio %s no existe. ¿Crearlo? " dir))
        (make-directory dir t)))
    ;; Advertir si el archivo ya existe
    (if (file-exists-p filename)
        (unless (y-or-n-p (format "%s ya existe. ¿Sobreescribir? " filename))
          (user-error "Operación cancelada"))
      )
    ;; Escribir y abrir
    (with-temp-file filename
      (insert content))
    (find-file filename)
    (goto-char (point-min))
    (message "dotnet-tools: creado %s" filename)))


;; ----------------------------
;; Comandos públicos
;; ----------------------------

;;;###autoload
(defun dotnet-tools-create-class ()
  "Crea una nueva clase C# en el directorio de trabajo .NET."
  (interactive)
  (dotnet-tools--create-file 'class))

;;;###autoload
(defun dotnet-tools-create-interface ()
  "Crea una nueva interface C# (prefijo I) en el directorio de trabajo .NET."
  (interactive)
  (dotnet-tools--create-file 'interface))

;;;###autoload
(defun dotnet-tools-create-controller ()
  "Crea un nuevo controller ASP.NET Core en el directorio de trabajo .NET."
  (interactive)
  (dotnet-tools--create-file 'controller))

;;;###autoload
(defun dotnet-tools-show-status ()
  "Muestra el estado actual de dotnet-tools en el minibuffer."
  (interactive)
  (let ((root (dotnet-tools--find-csproj-root)))
    (message "dotnet-tools | dir: %s | root detectado: %s"
             (or dotnet-tools-default-directory "sin configurar")
             (or root "no encontrado"))))


;; ----------------------------
;; Hydra
;; ----------------------------

(defmacro dotnet-tools--define-hydra ()
  "Define la hydra de dotnet-tools si el paquete hydra está disponible."
  `(when (require 'hydra nil 'noerror)
     (defhydra dotnet-tools-hydra (:color teal :hint nil)
       "
╔══════════════════════════════════╗
║        dotnet-tools  .NET        ║
╠══════════════════════════════════╣
║  _c_  nueva Clase                ║
║  _i_  nueva Interface            ║
║  _o_  nuevo Controller           ║
╠══════════════════════════════════╣
║  _d_  cambiar Directorio         ║
║  _s_  ver Status                 ║
╠══════════════════════════════════╣
║  _q_  salir                      ║
╚══════════════════════════════════╝
"
       ("c" dotnet-tools-create-class      "Clase")
       ("i" dotnet-tools-create-interface  "Interface")
       ("o" dotnet-tools-create-controller "Controller")
       ("d" dotnet-tools-set-directory     "Directorio")
       ("s" dotnet-tools-show-status       "Status")
       ("q" nil                            "Salir" :color blue))))

;; Intentar definir la hydra al cargar el paquete
(dotnet-tools--define-hydra)


(provide 'dotnet-tools)
;;; dotnet-tools.el ends here
