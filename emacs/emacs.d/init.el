(require 'package)
(package-initialize)
(require 'use-package)
(setq use-package-always-ensure nil) ;; Nix instala los paquetes

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(require 'user-ui)
(require 'user-files)
(require 'user-completion)
(require 'user-projects)
(require 'user-dev)
(require 'user-windows)
(require 'user-ewm)
(require 'user-misc)
(require 'user-reading)
(require 'user-org)
