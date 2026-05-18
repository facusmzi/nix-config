;;; facusmzi-dired.el --- file manager -*- lexical-binding: t; -*-

(use-package dired
  :custom
  (dired-dwim-target t)
  (dired-listing-switches "-lvah")
  :config
  (defun mu/dired-find-file ()
    (interactive)
    (if (file-directory-p (dired-get-file-for-visit))
        (dired-find-alternate-file)
      (dired-find-file)))
  (defun mu/dired-up-directory ()
    (interactive)
    (let ((buf (current-buffer)))
      (dired-up-directory)
      (kill-buffer buf)))
  (evil-set-initial-state 'dired-mode 'motion)
  (evil-define-key 'motion dired-mode-map
    (kbd "q")   #'mu/open-dispatcher
    (kbd "RET") #'mu/dired-find-file
    (kbd "h")   #'mu/dired-up-directory
    (kbd "l")   #'mu/dired-find-file
    (kbd "j")   #'dired-next-line
    (kbd "k")   #'dired-previous-line
    (kbd "o")   #'dired-create-directory
    (kbd "x")   #'dired-do-delete
    (kbd "r")   #'dired-do-rename
    (kbd "y")   #'dired-do-copy
    (kbd "R")   #'revert-buffer)
  (defun mu/dired-setup ()
    (hl-line-mode)
    (dired-hide-details-mode))
  (add-hook 'dired-mode-hook #'mu/dired-setup))

(provide 'facusmzi-dired)
;;; facusmzi-dired.el ends here
