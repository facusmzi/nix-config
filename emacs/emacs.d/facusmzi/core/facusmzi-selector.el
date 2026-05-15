;;; facusmzi-selector --- selection and winnowing -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-projectile)

(use-package selector
  :load-path "~/.config/emacs/lisp"
  :custom
  (completing-read-function #'selector-completing-read)
  (read-file-name-function #'selector-read-file-name)
  :config
  (global-set-key (kbd "M-x") 'selector-M-x)
  (evil-define-key 'normal selector-minibuffer-map (kbd "q") 'selector-quit)

  ;; ─── Fuentes de buffers ────────────────────────────────────

  (defun facusmzi/selector-eshell-buffers ()
    (selector-source-create
     "Shells"
     :candidates
     (mapcar (lambda (buf)
               (selector-candidate-create
                (concat "In " (facusmzi/replace-home (facusmzi/buffer-directory buf))
                        " (named " buf ")")
                :value buf))
             (cl-remove-if-not #'facusmzi/buffer-eshell-p (facusmzi/buffer-list)))
     :actions
     selector-buffer-actions))

  (defun facusmzi/selector-unaffiliated-buffers ()
    (selector-source-create
     "Buffers"
     :candidates
     (facusmzi/unaffiliated-buffers)
     :actions
     selector-buffer-actions))

  (defun facusmzi/selector-project-buffers ()
    (selector-source-create
     "Project Buffers"
     :candidates
     (when (projectile-project-p)
       (cl-remove-if #'facusmzi/buffer-boring-p (projectile-project-buffer-names)))
     :actions
     selector-buffer-actions))

  (defun facusmzi/selector-project-files ()
    (selector-source-create
     "Project Files"
     :candidates
     (when (projectile-project-p)
       (cl-loop with root = (projectile-project-root)
                for display in (projectile-current-project-files)
                collect (selector-candidate-create display
                          :value (expand-file-name display root))))
     :actions
     selector-file-actions))

  (defun facusmzi/selector-create-file-or-buffer ()
    (selector-source-create
     "Other"
     :candidates
     (list (selector-candidate-create
            "Create buffer"
            :type 'dummy
            :action (lambda (_) (switch-to-buffer (selector-input))))
           (selector-candidate-create
            "Create file"
            :type 'dummy
            :action (lambda (_) (find-file (selector-input)))))))

  ;; ─── Navegación principal ──────────────────────────────────
  ;; Equivalente al "o" del dispatcher de lcolonq
  (defun facusmzi/navigate ()
    (interactive)
    (selector
     (list
      (facusmzi/selector-project-buffers)
      (facusmzi/selector-unaffiliated-buffers)
      (facusmzi/selector-eshell-buffers)
      (facusmzi/selector-project-files)
      (selector-recentf-source)
      (facusmzi/selector-create-file-or-buffer))))

  ;; ─── Ejecutar comandos externos ────────────────────────────
  (defvar facusmzi/external-commands-list nil)
  (defun facusmzi/run-external-command ()
    (interactive)
    (setq facusmzi/external-commands-list
          (cl-loop
           for dir in (split-string (getenv "PATH") path-separator)
           when (and (file-exists-p dir) (file-accessible-directory-p dir))
           for lsdir = (cl-loop for i in (directory-files dir t)
                                for bn = (file-name-nondirectory i)
                                when (and (not (member bn completions))
                                          (not (file-directory-p i))
                                          (file-executable-p i))
                                collect bn)
           append lsdir into completions
           finally return (sort completions 'string-lessp)))
    (selector (list (selector-source-create
                     "Commands"
                     :candidates
                     facusmzi/external-commands-list
                     :actions
                     (list (lambda (cmd) (start-process cmd nil cmd)))))
              :initial "^"))

  ;; ─── Búsqueda con ripgrep ──────────────────────────────────
  (defun facusmzi/selector-rg ()
    "Buscar líneas con ripgrep."
    (interactive)
    (let ((query (read-string "rg: ")))
      (defun conv (x)
        (cons (car x) (cons (- (string-to-number (cadr x)) 1) (caddr x))))
      (defun all-in-file (key list)
        (--map (to-candidate (cdr it)) (--filter (s-equals? key (car it)) list)))
      (defun to-candidate (x)
        (selector-candidate-create (cdr x) :value (car x)))
      (let* ((result (with-temp-buffer
                       (call-process "rg" nil t nil "-n" query ".")
                       (buffer-string)))
             (lines (--map (conv (s-split-up-to ":" it 2))
                           (--filter (not (s-blank? it)) (s-split "\n" result))))
             (files (-uniq (-map #'car lines)))
             (sources (--map (selector-source-create
                              it
                              :candidates (all-in-file it lines)
                              :actions (selector-file-contents-actions it))
                             files)))
        (when (not (null sources))
          (selector sources))))))

(provide 'facusmzi-selector)
;;; facusmzi-selector.el ends here
