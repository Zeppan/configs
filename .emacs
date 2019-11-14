;;; package --- Summary
;;;
;;; Commentary:
;;; My config file, started in 2019. Emacs built in stuff is at the bottom.
;;; The package "use-package" is used to manage all of the packages.
;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package moe-theme
  :ensure t
  :config
  (load-theme 'moe-dark t))

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
  :init
  (add-hook 'prog-mode-hook 'flycheck-mode)
  :hook
  (flycheck-mode . flycheck-list-errors)
  :bind
  ("C-." . flycheck-next-error)
  ("C-," . flycheck-previous-error)
  :config
  (add-to-list 'display-buffer-alist
	       `(,(rx bos "*Flycheck errors*" eos)
		 (display-buffer-reuse-window
		  display-buffer-in-side-window)
		 (side            . bottom)
		 (reusable-frames . visible)
		 (window-height   . 0.20)))
  (use-package flycheck-pos-tip
    :ensure t
    :config (flycheck-pos-tip-mode))
  (use-package flycheck-color-mode-line
    :ensure t
    :hook (flycheck-mode . flycheck-color-mode-line-mode))
  )

(use-package company
  :ensure t
  :commands global-company-mode
  :bind
  (("C-RET" . company-manual-begin)
   ("<C-return>" . company-manual-begin)
   :map company-active-map
   ("TAB" . nil)
   ("<tab>" . nil))
  :init (progn
	  (global-company-mode))
  :config (progn
	    (setq company-tooltip-limit 20) ; bigger pop-up window
	    (setq company-idle-delay .3)    ; decrease delay
	    (setq company-echo-delay 0)     ; remove annoying blinking
	    (setq company-begin-commands '(self-insert-command))
	    )
  (use-package company-c-headers
    :ensure t
    :config
    (add-to-list 'company-backends 'company-c-headers))
  (use-package company-irony
    :ensure t
    :config
    (eval-after-load 'company
      '(add-to-list 'company-backends 'company-irony)))
  )

(use-package irony
  :ensure t
  :hook
  (irony-mode . irony-cdb-autosetup-compile-options)
  )

(use-package helm
  :ensure t
  :config
  (helm-mode t)
  (use-package helm-gtags
    :ensure t
    :hook (c-mode . helm-gtags-mode)
    :bind ("<f6>" . helm-gtags-find-tag)))

(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

(use-package highlight-indent-guides
  :ensure t
  :init
  :hook
  (prog-mode . highlight-indent-guides-mode))

(use-package whitespace
  :init
  (global-whitespace-mode)
  :hook
  (prog-mode . whitespace-mode)
  (before-save . delete-trailing-whitespace)
  :config
  (setq whitespace-line-column 80)
  (setq-default whitespace-style '(face trailing tab-mark)))

(use-package google-this
  :ensure t
  :bind ("C-c g" . google-this)
  :config (google-this-mode 1))

(use-package ace-jump-mode
  :ensure t
  :bind
  ("C-c SPC" . ace-jump-word-mode)
  ("C-c C-g" . ace-jump-line-mode))

(use-package org
  :ensure t
  :init
  (setq org-agenda-files (list "~/org/OrgTutorial.org"))
  :hook (org-mode . turn-on-flyspell)
  :bind
  ("\C-cl" . org-store-link)
  ("\C-ca" . org-agenda))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package expand-region
  :ensure t
  :bind ("<f7>" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :bind ("<f8>" . mc/mark-next-like-this))

(use-package groovy-mode
  :ensure t)

(use-package flymd
  :ensure t)

(use-package cmake-mode
  :ensure t)

(use-package highlight-doxygen
  :ensure t
  :hook (c-mode . highlight-doxygen-mode))

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :bind
  ("C-x b" . ivy-switch-buffer)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-ignore-buffers '("\\*")))

;; Built in emacs stuff
;; Remove toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)
;; Remove the scroll bar
(toggle-scroll-bar -1)
;; Highlights the current line
(global-hl-line-mode 1)
;; Pair () [] {} etc.
(electric-pair-mode 1)
;; Shows the column number
(column-number-mode 1)
;; highligts the parenthesis pair
(show-paren-mode 1)
;; Removes the start screen
(setq inhibit-startup-screen t)

(global-set-key (kbd "<backtab>") (lambda ()
				    (interactive)
				    (other-window -1)))
(global-set-key (kbd "C-<tab>") (lambda ()
				  (interactive)
				  (other-window 1)))

(defun line-hook()
  "Add line numbers."
  (linum-mode 1))
(add-hook 'prog-mode-hook 'line-hook)

(defun indent-hook()
  "Indent before saving."
  (indent-region (point-min) (point-max))nil)
(add-hook 'before-save-hook 'indent-hook)

(defun c-hook()
  "Setup for C programming."
  (c-set-style "linux")
  (semantic-mode t))
(add-hook 'c-mode-hook 'c-hook)

;;; .emacs ends here
