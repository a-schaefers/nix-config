;;; -*- lexical-binding: t; -*-

;; GENERAL

(defun my-prog-mode-hook ()
  (goto-address-prog-mode 1))
(add-hook 'prog-mode-hook 'my-prog-mode-hook)

(require 'better-defaults)

(delete-selection-mode 1)
(blink-cursor-mode -1)
(setq visible-bell nil)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 8)
(setq-default fill-column 80)

(global-unset-key (kbd "C-z"))

(setq vc-follow-symlinks t)

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x"))))

(setq tab-always-indent 'complete)

(setq tramp-default-method "ssh")
(setq tramp-copy-size-limit nil)

(require 'whitespace)
(add-hook 'before-save-hook 'whitespace-cleanup)
(setq whitespace-line-column 80)
(setq whitespace-style '(face tabs empty trailing lines-tail))
(whitespace-mode 1)

(require 'recentf)
(setq recentf-max-saved-items 500
      recentf-max-menu-items 15)
(recentf-mode +1)

(require 'paren)
(show-paren-mode 1)

(require 'elec-pair)
(electric-pair-mode 1)

(require 'magit)
(global-set-key (kbd "C-c g") #'magit-status)
(setq magit-diff-refine-hunk t)
(setq magit-repository-directories '(("~/repos" . 1)))
(when (file-directory-p "/nix-config")
  (add-to-list 'magit-repository-directories '("/nix-config" . 0)))
(with-eval-after-load 'projectile
  (when (require 'magit nil t)
    (mapc #'projectile-add-known-project
          (mapcar #'file-name-as-directory (magit-list-repos)))
    (projectile-save-known-projects)))

(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode 1)

(require 'dumb-jump)
(global-set-key (kbd "C-c .") #'dumb-jump-go)
(global-set-key (kbd "C-c ,") #'dumb-jump-back)
(dumb-jump-mode 1)

(require 'flycheck)
(setq flycheck-emacs-lisp-load-path 'inherit)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-display-errors-function nil)
(global-flycheck-mode 1)

(require 'rainbow-delimiters)

(require 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)

(require 'crux)
(crux-reopen-as-root-mode 1)
(global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
(global-set-key [remap kill-whole-line] #'crux-kill-whole-line)
(global-set-key (kbd "<C-S-return>") #'crux-smart-open-line-above)
(global-set-key (kbd "<S-return>") #'crux-smart-open-line)
(global-set-key (kbd "C-c r") #'crux-recentf-find-file)
(global-set-key (kbd "C-c R") #'crux-rename-buffer-and-file)
(global-set-key (kbd "C-<backspace>") #'crux-kill-line-backwards)
(global-set-key (kbd "C-c u") 'crux-view-url)
(global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-c M-d") 'crux-duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "C-c D") #'crux-delete-buffer-and-file)
(global-set-key (kbd "C-c I") 'crux-find-user-init-file)

(require 'ace-window)
(global-set-key [remap other-window] 'ace-window)
(setq aw-scope 'frame)
(ace-window-display-mode -1)

(require 'webpaste)

(require 'aggressive-indent)
(aggressive-indent-global-mode 1)

;; BASH

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
(setq explicit-shell-file-name "bash")
(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)
(require 'bash-completion)
(defun my-shell-mode-hook()
  (setq-local compile-command
              '((lambda()
                  (save-buffer)
                  (async-shell-command (buffer-file-name))))))
(add-hook 'sh-mode-hook 'my-shell-mode-hook)

;;;;; EMACS LISP & CLOJURE

(require 'lisp-mode)
(defun my-ielm ()
  (interactive)
  (crux-start-or-switch-to 'ielm "*ielm*"))
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(define-key emacs-lisp-mode-map (kbd "C-c C-z") 'my-ielm)
(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-defun)
(define-key emacs-lisp-mode-map (kbd "C-c C-b") 'eval-buffer)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)

(require 'ielm)
(add-hook 'ielm-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)

(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
;; enable in the *scratch* buffer
(add-hook 'lisp-interaction-mode-hook 'paredit-mode)
(add-hook 'ielm-mode-hook 'paredit-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode)

(require 'clojure-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(require 'cider)
(setq nrepl-log-messages t)
(add-hook 'cider-mode-hook 'eldoc-mode)
(add-hook 'cider-repl-mode-hook 'eldoc-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

;;;; HASKELL

(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'subword-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)

;;;; NIX

(require 'nix-mode)