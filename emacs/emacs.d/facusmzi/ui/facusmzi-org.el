;;; facusmzi-org --- outlining and productivity -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)

;; ─── Org base ──────────────────────────────────────────────
(use-package org
  :custom
  (org-directory "~/notes")
  (org-default-notes-file "~/notes/scratch.org")
  (org-agenda-files '("~/notes"))
  (org-log-done 'time)
  (org-goto-interface 'outline-path-completion)
  (org-outline-path-complete-in-steps nil)
  (org-todo-keywords '((sequence "TODO" "STUCK" "|" "DONE" "DROPPED")))
  (org-src-preserve-indentation t)
  (org-src-window-setup 'current-window)
  (org-export-date-timestamp-format "%Y/%m/%d")
  (org-confirm-babel-evaluate nil)
  (org-refile-targets '((nil :maxlevel . 9)
                        (org-agenda-files :maxlevel . 9)))
  (org-image-actual-width nil)
  (org-list-allow-alphabetical t)
  :config

  ;; ─── Babel ───────────────────────────────────────────────
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (C . t)))

  ;; ─── Evil bindings ───────────────────────────────────────
  (evil-define-key 'normal org-mode-map
    (kbd "H")   'org-shiftleft
    (kbd "L")   'org-shiftright
    (kbd "M-H") 'org-metaleft
    (kbd "M-J") 'org-metadown
    (kbd "M-K") 'org-metaup
    (kbd "M-L") 'org-metaright
    (kbd "C-h") 'org-shiftmetaleft
    (kbd "C-j") 'org-shiftmetadown
    (kbd "C-k") 'org-shiftmetaup
    (kbd "C-l") 'org-shiftmetaright
    (kbd "RET") 'org-open-at-point)

  ;; ─── IDE hydra ───────────────────────────────────────────
  (defhydra facusmzi/ide-org (:color teal :hint nil)
    "Dispatcher > Org IDE"
    ("<f12>" keyboard-escape-quit)
    ("i" org-ctrl-c-ctrl-c "poke")
    ("o" org-goto "goto")
    ("h" org-html-export-to-html "html")
    ("v" org-latex-export-to-pdf "pdf")
    ("w" org-babel-tangle "tangle")
    ("x" org-export-dispatch "export")
    ("r" (command-execute
          (if org-capture-mode 'org-capture-refile 'org-refile)) "refile")
    ("e" org-edit-special "edit src")
    ("s" org-schedule "schedule")
    ("p" org-set-property "prop")
    ("t" org-todo "todo")
    ("c" org-toggle-checkbox "check")
    ("l" org-toggle-link-display "links")
    ("f" org-toggle-latex-fragment "tex")
    ("m" org-toggle-inline-images "images"))

  ;; ─── Faces ───────────────────────────────────────────────
  (set-face-attribute 'org-todo nil :box nil)
  (set-face-attribute 'org-done nil :box nil)
  (set-face-attribute 'org-checkbox-statistics-todo nil :box nil)
  (set-face-attribute 'org-checkbox-statistics-done nil :box nil)
  (set-face-attribute 'org-scheduled-today nil :foreground nil)

  ;; ─── Setup hooks ─────────────────────────────────────────
  (defun facusmzi/org-setup ()
    (setq-local evil-auto-indent nil)
    (setq-local facusmzi/contextual-ide #'facusmzi/ide-org/body)
    (local-unset-key (kbd "M-h"))
    (org-indent-mode))
  (add-hook 'org-mode-hook #'facusmzi/org-setup)

  ;; Cuando editás un bloque src: w guarda, SPC/k salen
  (defun facusmzi/org-src-setup ()
    (when (eq major-mode 'emacs-lisp-mode)
      (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
    (setq-local facusmzi/contextual-write #'org-edit-src-save)
    (setq-local facusmzi/contextual-quit  #'org-edit-src-exit)
    (setq-local facusmzi/contextual-kill  #'org-edit-src-exit)
    (setq-local header-line-format "Editando bloque fuente — w guarda, k sale"))
  (add-hook 'org-src-mode-hook #'facusmzi/org-src-setup))

;; ─── Org attach ────────────────────────────────────────────
(use-package org-attach
  :custom
  (org-attach-id-dir "~/notes/attach"))

;; ─── Org roam ──────────────────────────────────────────────
(defvar org-roam-v2-ack t)

(use-package org-roam
  :custom
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-db-location "~/.local/share/org-roam/org-roam.db")
  (org-roam-directory "~/notes")
  (org-roam-completion-everywhere t)
  (org-roam-link-auto-replace t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-note.org" "#+title: ${title}\n")
      :unnarrowed t
      :immediate-finish t)))
  (org-roam-dailies-capture-templates
   '(("d" "daily" plain "%?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+filetags: log")
      :unnarrowed t
      :immediate-finish t)))
  :config
  (org-roam-db-autosync-mode)

  ;; ─── Agenda dispatcher ───────────────────────────────────
  (defhydra facusmzi/agenda-dispatcher (:color teal :hint nil)
    "Dispatcher > Notas"
    ("<f12>" keyboard-escape-quit)
    ("a" org-roam-buffer-toggle "display")
    ("i" org-roam-node-insert "insertar link")
    ("f" org-roam-node-find "buscar nota")
    ("t" org-roam-dailies-find-today "hoy")
    ("T" org-roam-dailies-find-date "fecha")
    ("p" org-publish "publicar")))

(provide 'facusmzi-org)
;;; facusmzi-org.el ends here
