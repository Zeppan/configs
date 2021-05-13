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

(use-package monokai-theme
  :ensure t
  :config
  (load-theme 'monokai t))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*Flycheck errors*" eos)
		 (display-buffer-reuse-window
		  display-buffer-in-side-window)
		 (side            . bottom)
		 (reusable-frames . visible)
		 (window-height   . 0.23)))
  )

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (rust-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  (lsp-mode . flycheck-list-errors)
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-doc-position 'at-point
	lsp-ui-sideline-ignore-duplicate t)
  :commands lsp-ui-mode)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :config
  (lsp-treemacs-sync-mode 1)
  :commands lsp-treemacs-errors-list)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package company
  :ensure t)

(use-package powerline
  :ensure t
  :init
  (powerline-default-theme))

(use-package highlight-indent-guides
  :ensure t
  :init
  :hook
  (prog-mode . highlight-indent-guides-mode))

(use-package projectile
  :ensure t)

(use-package whitespace
  :init
  (global-whitespace-mode)
  :hook
  (prog-mode . whitespace-mode)
  (before-save . delete-trailing-whitespace)
  :config
  (setq whitespace-line-column 80)
  (setq-default whitespace-style '(face trailing tab-mark)))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package expand-region
  :ensure t
  :bind ("<f7>" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :bind ("<f8>" . mc/mark-next-like-this))

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)
  :bind
  ("C-x b" . ivy-switch-buffer)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-ignore-buffers '("\\*"))
  )

(use-package stickyfunc-enhance
  :ensure t
  :config
  (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
  )

(use-package smooth-scrolling
  :ensure t
  :init (smooth-scrolling-mode 1))

;; Rust stuff
(use-package rust-mode
  :ensure t
  :hook
  (rust-mode-hook . (lambda() (setq indent-tabs-mode nil)))
  (rust-mode-hook . lsp-ui-flycheck-list)
  :config (setq rust-format-on-save t)
  (autoload 'rust-mode "rust-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
  :bind
  ("C-c C-c" . rust-compile)
  ("C-c C-r" . rust-run)
  ("C-c C-t" . rust-test)
  )
;; ************************************************** ;;
(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  )

;; Built in emacs stuff
;; Remove toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)
;; Remove the scroll bar
(toggle-scroll-bar -1)
;; Highlights the current line
;;(global-hl-line-mode 1)
;; Pair () [] {} etc.
(electric-pair-mode 1)
;; Shows the column number
(column-number-mode 1)
;; highligts the parenthesis pair
(show-paren-mode 1)
;; Removes the start screen
(setq inhibit-startup-screen t)
;; Display the time on status bar
(display-time-mode 1)

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

;;; .emacs ends here
