(doom! :completion
       vertico

       :ui
       doom
       doom-dashboard
       modeline
       (popup +defaults)

       :editor
       evil
       snippets

       :emacs
       dired
       undo

       :term
       eshell

       :checkers
       syntax

       :tools
       (lsp +eglot)
       magit
       direnv

       :lang
       emacs-lisp
       (haskell +lsp)
       (org +pretty +roam2)
       (nix +lsp)

       :config
       (default +bindings +smartparens))
