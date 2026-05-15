;;; facusmzi-terminal.el --- terminal -*- lexical-binding: t; -*-

(defun mu/term-here ()
  "Abrir terminal en el directorio actual."
  (interactive)
  (let ((default-directory default-directory))
    (eat)))

(use-package eat
  :hook
  (eshell-mode . eat-eshell-mode)
  :config
  (setq eat-kill-buffer-on-exit t))

(provide 'facusmzi-terminal)
;;; facusmzi-terminal.el ends here
