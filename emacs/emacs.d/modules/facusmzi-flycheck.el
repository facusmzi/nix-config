;;; facusmzi-flycheck.el --- errores inline -*- lexical-binding: t; -*-

(use-package flycheck
  :custom
  (flycheck-display-errors-delay 0.1)
  (flycheck-check-syntax-automatically '(save mode-enabled))
  :config
  (global-flycheck-mode))

(use-package quick-peek)

(use-package flycheck-inline
  :config
  (setq flycheck-inline-display-function
        (lambda (msg &optional pos err)
          (ignore err)
          (set-text-properties 0 (length msg) nil msg)
          (let* ((ov (quick-peek-overlay-ensure-at pos))
                 (contents (quick-peek-overlay-contents ov)))
            (setf (quick-peek-overlay-contents ov)
                  (concat contents (when contents "\n") msg))
            (quick-peek-update ov)))
        flycheck-inline-clear-function #'quick-peek-hide)
  (global-flycheck-inline-mode))

(provide 'facusmzi-flycheck)
;;; facusmzi-flycheck.el ends here
