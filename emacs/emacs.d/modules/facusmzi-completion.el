;;; facusmzi-completion.el --- completion y navegación -*- lexical-binding: t; -*-

;; Vertico: UI vertical para el minibuffer
(use-package vertico
  :config
  (vertico-mode 1)
  (setq vertico-count 15
        vertico-cycle t)
        ;; Navegación evil en vertico
  (evil-define-key 'normal vertico-map
    (kbd "q")  #'abort-minibuffers
    (kbd "j")  #'vertico-next
    (kbd "k")  #'vertico-previous
    (kbd "G")  #'vertico-last
    (kbd "gg") #'vertico-first
    (kbd "RET") #'vertico-exit))

;; Orderless: matching por palabras separadas por espacios
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia: anotaciones en los candidatos
(use-package marginalia
  :config
  (marginalia-mode 1))

;; Consult: comandos mejorados
(use-package consult
  :config
  ;; Ripgrep como backend de búsqueda
  (setq consult-ripgrep-args
        "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --search-zip"))

(provide 'facusmzi-completion)
;;; facusmzi-completion.el ends here
