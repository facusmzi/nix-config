;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ============================================================================
;; CONFIGURACIÓN BÁSICA
;; ============================================================================

(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")

;; ============================================================================
;; C# Y OMNISHARP
;; ============================================================================

(after! csharp-mode
  (add-hook 'csharp-mode-hook #'lsp!)
  (setq c-basic-offset 4)
  (setq csharp-tree-sitter-indent-offset 4))

(after! lsp-mode
  (setq lsp-csharp-server-path "omnisharp")
  (setq lsp-idle-delay 0.1)
  (setq lsp-log-io nil)
  (setq lsp-completion-enable t)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t))

(after! company
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-show-numbers t))

;; ============================================================================
;; VTERM
;; ============================================================================

(map! :leader
      (:prefix-map ("o" . "open")
       "t" #'+vterm/here))

;; ============================================================================
;; ORG-ROAM
;; ============================================================================

(setq org-roam-directory (file-truename "~/org-roam/"))

(use-package! org-roam
  :custom
  (org-roam-directory (file-truename "~/org-roam/"))
  :config
  (org-roam-db-autosync-mode))

(map! :leader
      :desc "Find node" "n r f" #'org-roam-node-find
      :desc "Insert node" "n r i" #'org-roam-node-insert
      :desc "Toggle roam buffer" "n r r" #'org-roam-buffer-toggle)

;; Configuración de display para org-roam
(setq org-roam-buffer-visibility 'default)

(setq display-buffer-alist
      (append
       '(("\\*org-roam\\*"
          (display-buffer-reuse-window display-buffer-same-window)))
       display-buffer-alist))

;; ============================================================================
;; ORG BABEL CON PYTHON Y MATPLOTLIB
;; ============================================================================

(after! org
  ;; Habilitar lenguajes
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (emacs-lisp . t)
     (dot . t)
     (plantuml . t)
     (C . t)
     (csharp . t)))

  ;; Configuración de Python
  (setq org-babel-python-command "python3")

  ;; Fix para archivos binarios
  (setq org-babel-python-wrapper-method
        "
def main():
%s

if __name__ == '__main__':
    main()")

  (setq org-babel-python-pp-wrapper-method
        "
import pprint
def main():
%s

if __name__ == '__main__':
    main()")

  ;; Configuración general
  (setq org-confirm-babel-evaluate nil)
  (setq org-image-actual-width '(600))
  (setq org-startup-with-inline-images t)

  ;; Auto-display de imágenes
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
  (add-hook 'org-babel-after-execute-hook
            (lambda () (org-redisplay-inline-images)) 'append)

  ;; Mejor experiencia en src blocks
  (setq org-src-tab-acts-natively t)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t))

;; Keybindings para Org
(map! :map org-mode-map
      :localleader
      :desc "Toggle inline images" "i i" #'org-toggle-inline-images
      :desc "Redisplay inline images" "i r" #'org-redisplay-inline-images
      :desc "Execute code block" "e" #'org-babel-execute-src-block)

;; Company en org-src blocks
(add-hook 'org-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-capf company-dabbrev-code company-files)))))

;; Snippet para matplotlib
(after! org
  (defun my/org-insert-matplotlib-block ()
    "Inserta un bloque de código Python con matplotlib configurado."
    (interactive)
    (let ((filename (read-string "Nombre del archivo (sin .png): " "grafico")))
      (insert (format "#+begin_src python :results none
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Tu código aquí

plt.savefig('%s.png', dpi=150, bbox_inches='tight')
plt.close()
#+end_src

#+RESULTS:

[[file:%s.png]]" filename filename))
      (forward-line -7)
      (end-of-line)))

  (map! :map org-mode-map
        :localleader
        :desc "Insert matplotlib block" "i p" #'my/org-insert-matplotlib-block))

;; ============================================================================
;; HASKELL CONFIGURATION
;; ============================================================================

(after! haskell-mode
  ;; Formateador
  (setq haskell-formatter-command "fourmolu")

  ;; Visual
  (when (featurep 'rainbow-delimiters)
    (add-hook 'haskell-mode-hook #'rainbow-delimiters-mode))
  (add-hook 'haskell-mode-hook #'display-line-numbers-mode)

  ;; Keybindings locales
  (map! :map haskell-mode-map
        :localleader
        ;; Formateo
        :desc "Format buffer" "=" #'haskell-format-buffer

        ;; REPL
        :desc "Load file in REPL" "l" #'haskell-process-load-file
        :desc "Switch to REPL" "z" #'haskell-interactive-switch

        ;; Type info
        (:prefix ("n" . "info")
         :desc "Type at point" "t" #'haskell-process-do-type
         :desc "Info at point" "i" #'haskell-process-do-info)

        ;; Build
        (:prefix ("c" . "cabal")
         :desc "Build" "b" #'haskell-process-cabal-build
         :desc "Cabal" "c" #'haskell-process-cabal))

  ;; Navegación de S-expressions
  (map! :map haskell-mode-map
        :n "C-)" #'forward-sexp
        :n "C-(" #'backward-sexp)

  ;; Configuración del proceso interactivo
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t
        haskell-process-log t
        haskell-tags-on-save nil)

  ;; Cabal mode
  (map! :map haskell-cabal-mode-map
        :localleader
        :desc "Switch to REPL" "z" #'haskell-interactive-switch
        :desc "Clear REPL" "k" #'haskell-interactive-mode-clear
        :desc "Build" "c" #'haskell-process-cabal-build
        :desc "Cabal command" "C" #'haskell-process-cabal)

  (map! :map haskell-cabal-mode-map
        :n "C-)" #'forward-sexp
        :n "C-(" #'backward-sexp))

;; LSP para Haskell
(use-package! lsp-haskell
  :after lsp-mode
  :config
  (setq lsp-haskell-server-path "haskell-language-server-wrapper")
  (setq lsp-idle-delay 0.1
        lsp-log-io nil)
  (setq lsp-completion-enable t
        lsp-completion-show-detail t
        lsp-completion-show-kind t)
  (setq lsp-haskell-formatting-provider "fourmolu")
  (setq lsp-haskell-plugin-ghcide-type-lenses-global-on nil))

;; Forzar LSP en haskell-mode
(add-hook! 'haskell-mode-hook
  (defun +haskell-lsp-setup-h ()
    "Forzar inicio de LSP en Haskell."
    (when (and (bound-and-true-p lsp-mode)
               (not lsp--buffer-workspaces))
      (lsp-deferred))))

(add-hook 'haskell-mode-hook #'lsp! 'append)
(add-hook 'haskell-literate-mode-hook #'lsp! 'append)

;; LSP-UI
(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t))

;; Función para formatear con fourmolu
(defun haskell-format-buffer ()
  "Format current buffer with fourmolu."
  (interactive)
  (let ((p (point)))
    (shell-command-on-region (point-min) (point-max)
                             haskell-formatter-command
                             nil t)
    (goto-char p)))

;; Keybindings globales para Haskell
(map! :after haskell-mode
      :map haskell-mode-map
      :localleader
      :desc "Type at point (LSP)" "t" #'lsp-describe-thing-at-point
      :desc "Find definition" "d" #'lsp-find-definition
      :desc "Find references" "r" #'lsp-find-references
      :desc "Rename" "R" #'lsp-rename)

;; Hooks finales
(add-hook! 'haskell-mode-hook
  (setq-local company-idle-delay 0.1))
