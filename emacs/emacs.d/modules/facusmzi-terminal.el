;;; mu-term.el --- terminal -*- lexical-binding: t; -*-

(use-package eat
  :hook
  (eshell-mode . eat-eshell-mode)
  :config
  (setq eat-kill-buffer-on-exit t)

  (defun mu/term-here ()
    "Abrir terminal en el directorio actual."
    (interactive)
    (eat default-directory)))

(provide 'facusmzi-terminal)
;;; mu-term.el ends here
