;; Speeds up startup times, changes reverted after startup is complete
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist-original file-name-handler-alist
      file-name-handler-alist nil
      frame-inhibit-implied-resize t)

;; No package.el en el arranque
(setq package-enable-at-startup nil
      package--init-file-ensured t)
