;;; facusmzi-vc.el --- version control -*- lexical-binding: t; -*-

(use-package magit
  :config
  (setq magit-no-message '("Turning on"))

  ;; Keybindings vim-like en magit
  (evil-define-key 'motion magit-mode-map
    (kbd "RET") #'magit-visit-thing
    (kbd "TAB") #'magit-section-cycle
    (kbd "R")   #'magit-refresh
    (kbd "s")   #'magit-stage
    (kbd "u")   #'magit-unstage
    (kbd "x")   #'magit-discard
    (kbd "zo")  #'magit-section-show
    (kbd "zc")  #'magit-section-hide))

(provide 'facusmzi-vc)
;;; facusmzi-vc.el ends here
