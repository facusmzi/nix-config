;;; facusmzi-core --- core functionality -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(add-to-list 'load-path "~/.config/emacs/facusmzi/core")
(require 'facusmzi-package)
(require 'facusmzi-defaults)
(require 'facusmzi-utility)
(require 'facusmzi-evil)
(require 'facusmzi-hydra)
(require 'facusmzi-dispatcher)
(require 'facusmzi-projectile)
(require 'facusmzi-selector)
(require 'facusmzi-vc)

(provide 'facusmzi-core)
;;; facusmzi-core.el ends here
