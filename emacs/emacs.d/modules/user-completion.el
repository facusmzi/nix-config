;;; user-completion.el --- Vertico, Orderless, Marginalia, Consult, Helpful -*- lexical-binding: t -*-

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  (enable-recursive-minibuffers t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("C-x C-f" . find-file)
         ("C-c r"   . consult-recent-file)
         ("C-s"     . consult-line)
         ("C-c i"   . consult-imenu)
         :map minibuffer-local-map
         ("C-r" . consult-history)))

;; Buscar símbolos en todo el workspace via LSP (equivalente a Ctrl+T en VSCode)
(use-package consult-eglot
  :after (consult eglot)
  :bind (:map eglot-mode-map
              ("C-c l s" . consult-eglot-symbols)))

(use-package helpful
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key))

(provide 'user-completion)
;;; user-completion.el ends here
