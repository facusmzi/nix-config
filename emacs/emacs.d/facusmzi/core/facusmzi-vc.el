;;; facusmzi-vc --- version control -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'facusmzi-package)
(require 'facusmzi-hydra)

;; Deshabilitar el sistema de vc built-in de Emacs — usamos magit para todo
(use-package vc
  :custom
  (vc-handled-backends nil)
  :config
  (remove-hook 'find-file-hook 'vc-refresh-state))

(use-package magit
  :custom
  (magit-no-message '("Turning on"))
  ;; TODO: descomentar cuando tengamos facusmzi-selector
  (magit-completing-read-function #'selector-completing-read)
  :config

  ;; ─── VC dispatcher ────────────────────────────────────────
  (defhydra facusmzi/vc-dispatcher (:color teal :hint nil)
    "Dispatcher > Version Control"
    ("<f12>" keyboard-escape-quit)
    ("v" magit-status "status")
    ("h" magit-log-buffer-file "history")
    ("l" magit-log-current "log")
    ("f" magit-log-buffer-file "file")
    ("d" (magit-diff-range "master") "diff")
    ("s" magit-checkout "switch")
    ("S" magit-branch-and-checkout)
    ("t" magit-stash-list "stash")
    ("b" magit-blame-addition "blame")
    ("q" magit-blame-quit "quit-blame")
    ("T" magit-stash-worktree)
    ("c" magit-commit-create "commit")
    ("p" magit-push-current-to-upstream "push")
    ("u" magit-pull-from-upstream "pull"))

  ;; Reemplazar los keymaps de magit con keymaps vacíos para no pisar evil
  (setq
   magit-mode-map (make-keymap)
   magit-status-mode-map (make-keymap)
   magit-diff-mode-map (make-keymap)
   magit-stashes-mode-map (make-keymap))

  ;; Bindings de magit en motion state (lcolonq style)
  (evil-define-key 'motion magit-mode-map
    (kbd "RET") #'magit-visit-thing
    (kbd "TAB") #'magit-section-cycle
    (kbd "R")   #'magit-refresh
    (kbd "s")   #'magit-stage
    (kbd "u")   #'magit-unstage
    (kbd "x")   #'magit-discard
    (kbd "zo")  #'magit-section-show
    (kbd "zc")  #'magit-section-hide
    (kbd "zR")  #'magit-section-show-level-4-all
    (kbd "zM")  #'magit-section-hide-children))

;; ─── with-editor ──────────────────────────────────────────
;; Integración contextual para commits — w guarda, SPC cancela
(use-package with-editor
  :config
  (defun facusmzi/with-editor-setup ()
    (setq-local facusmzi/contextual-write 'with-editor-finish)
    (setq-local facusmzi/contextual-kill 'with-editor-cancel))
  (add-hook 'with-editor-mode-hook 'facusmzi/with-editor-setup))

(provide 'facusmzi-vc)
;;; facusmzi-vc.el ends here
