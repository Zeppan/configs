;;; Package --- Summary
;;
;;; Commentary:

;;; code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t))

(use-package fill-column-indicator
  :ensure t
  :init
  :config
   (setq fci-rule-column 80)
   (setq fci-rule-width 1)
   (setq fci-rule-color "red")
  :hook (c-mode . fci-mode))

(use-package flycheck
  :ensure t
  :commands global-flycheck-mode
  :init (global-flycheck-mode))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :commands flycheck-pos-tip-mode
  :init (flycheck-pos-tip-mode))

(use-package company
  :ensure t
  :commands global-company-mode
  :init (progn
	  (global-company-mode))
  :config (progn
	    (setq company-tooltip-limit 20) ; bigger pop-up window
	    (setq company-idle-delay .3)    ; decrease delay
	    (setq company-echo-delay 0)     ; remove annoying blinking
	    (setq company-begin-commands '(self-insert-command))
	    ))

(use-package helm
  :ensure t
  :config
  (helm-mode t))

(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

(use-package highlight-indent-guides
  :ensure t
  :init
  :hook
  (prog-mode . highlight-indent-guides-mode)

(use-package whitespace
  :init
  (global-whitespace-mode)
  :hook
  (prog-mode . whitespace-mode)
  (before-save . delete-trailing-whitespace)
  :config
    (setq whitespace-line-column 80)
    (setq-default whitespace-style '(face trailing tab-mark)))

;; Built in emacs stuff
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(global-hl-line-mode 1)
(electric-pair-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(defun line-hook()
  (linum-mode 1))
(add-hook 'prog-mode-hook 'line-hook)

(setq initial-frame-alist
      '(
	(width . 90)
	(height . 65)
	))


;; Code style
(defun my-c-mode-hook ()
  "Set-up for C-programming."
  (setq c-default-style "linux")
  (setq c-basic-offset 8))
(add-hook 'c-mode-hook 'my-c-mode-hook)


;;; .emacs ends here
