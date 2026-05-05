;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       company
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       workspaces

       :editor
       evil
       file-templates
       fold
       (format +onsave)
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       (spell +flyspell)

       :tools
       (eval +overlay)
       (lookup +dictionary +offline +docsets)
       (lsp +eglot)
       magit
       direnv
       tree-sitter

       :lang
       emacs-lisp
       (haskell +lsp +tree-sitter)
       markdown
       (nix +lsp)
       (org +pretty +roam)
       (rust +lsp +tree-sitter)
       sh

       :app
       (rss +org)

       :config
       (default +bindings +smartparens))
