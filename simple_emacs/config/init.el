;;; init.el --- Initial configuration -*- lexical-binding: t; -*-

(require 'avy)
(require 'evil)
(require 'evil-nerd-commenter)
(require 'general)
(require 'nix-mode)
(require 'jsonnet-mode)
(require 'vterm)
(require 'multi-vterm)
(require 'ivy)
(require 'counsel)
(require 'magit)
(require 'dash)

;; NOTE: Even though I use nix to build and manage my Emacs
;; configuration sometimes I like to try packages out without doing a
;; full nix-build and restarting my Emacs session and breaking
;; context.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Settings for GUI versus terminal
(if (display-graphic-p)
    (progn
      (load-theme 'modus-vivendi)
      (setq initial-buffer-choice "~/programming/base"))
  (setq initial-buffer-choice nil))

(require 'lsp-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(setq lsp-idle-delay 0.1)

(require 'company)
(setq company-idle-delay 0.0
      company-minimum-prefix-length 1)

;; NOTE: In Emacs :height is 1/10pt, so 120 => 12pt, 140 => 14pt
(set-face-attribute 'default nil :family "CaskaydiaMono Nerd Font" :height 150)

;; Disable bold/italics
(-map (lambda (x)
        (set-face-attribute x nil :slant 'normal :weight 'normal))
      (face-list))

(setq make-backup-files nil) ;; #foo#
(setq auto-save-default nil) ;; foo~
(setq create-lockfiles nil)  ;; .#foo
(setq-default truncate-lines t)
(setq scroll-step 1)
(setq dired-listing-switches "-al --group-directories-first")
(setq-default c-basic-offset 2) ;; clang-format --style=Google
(setq-default indent-tabs-mode nil)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Support Typescript-JSX files
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . javascript-mode))

(evil-mode 1)
(evilnc-default-hotkeys)
(setq evil-symbol-word-search t)
(ivy-mode 1)

(define-key evil-normal-state-map "-" #'dired-jump)
(define-key evil-normal-state-map "H" #'evil-first-non-blank)
(define-key evil-normal-state-map "L" #'evil-end-of-line)

(general-unbind 'normal "s")
(general-unbind 'insert "C-v" "C-d" "C-a" "C-e" "C-n" "C-p" "C-k" "C-r")

(general-define-key
 :states 'normal
 :prefix "s"
 "k" #'evil-window-split
 "j" '(lambda () (interactive) (evil-window-split) (windmove-down))
 "h" #'evil-window-vsplit
 "l" '(lambda () (interactive) (evil-window-vsplit) (windmove-right)))

(general-define-key
 :states 'normal
 :keymaps 'dired-mode-map
 "M--" #'evil-window-split
 "M-\\" #'evil-window-vsplit
 "-" #'dired-up-directory
 "f" #'project-find-file
 "%" #'dired-create-empty-file)

(general-define-key
 :states 'normal
 :prefix "SPC"
 "w" #'save-buffer
 "f" #'project-find-file
 "b" #'counsel-switch-buffer
 "k" #'kill-buffer
 "I" #'ibuffer
 "hf" #'describe-function
 "gs" #'magit-status
 "ee" '(lambda () (interactive) (find-file "~/programming/dotfiles/simple_emacs/config/init.el"))
 "jb" '(lambda () (interactive) (find-file "~/programming/base"))
 "jd" '(lambda () (interactive) (find-file "~/programming/dotfiles")))


(evil-set-initial-state 'vterm-mode 'insert)

(global-set-key (kbd "C-s-t")
                (lambda ()
                  (interactive)
                  (-let [(lhs rhs) (-separate (lambda (x) (eq 'vterm-mode (with-current-buffer x major-mode))) (buffer-list))]
                    (if (eq 'vterm-mode (with-current-buffer (current-buffer) major-mode))
                        (switch-to-buffer (car rhs))
                      (if (null lhs) (multi-vterm)
                        (switch-to-buffer (car lhs)))))))

(general-define-key
 :keymaps 'vterm-mode-map
 "M-:" nil
 "C-<tab>" #'multi-vterm-next
 "C-S-<tab>" #'multi-vterm-prev
 "M--" #'evil-window-split
 "M-\\" #'evil-window-vsplit
 "C-S-n" #'multi-vterm)

(general-define-key
 :keymaps 'vterm-mode-map
 :states 'insert
 "C-u" #'vterm--self-insert
 "C-o" #'vterm--self-insert ;; need this to close vim
 "C-a" #'vterm--self-insert
 "C-e" #'vterm--self-insert
 "C-f" #'vterm--self-insert
 "C-b" #'vterm--self-insert
 "<deletechar>" #'vterm-send-delete)

(general-define-key
 :keymaps 'override
 "C-;" #'avy-goto-char
 "C-`" #'multi-vterm-dedicated-toggle ;; vscode inspiration
 "M-k" #'windmove-up
 "M-j" #'windmove-down
 "M-h" #'windmove-left
 "M-l" #'windmove-right
 "M-q" #'delete-window)

(general-define-key
 :states 'normal
 :keymaps 'ibuffer-mode-map
 "M-j" nil
 "K" #'ibuffer-do-delete)

;; emulating the gitui KBDs
(general-define-key
 :keymaps 'magit-status-mode-map
 "e" #'magit-diff-visit-file
 "V" #'set-mark-command
 "D" #'magit-delete-thing)

(general-define-key
 :keymaps '(magit-status-mode-map
            magit-revision-mode-map
            magit-log-mode-map)
 "<up>"   #'magit-previous-line
 "<down>" #'magit-next-line
 "k"      #'magit-previous-line
 "j"      #'magit-next-line)

;; Reuse the current buffer when opening magit-status
(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)

(provide 'init)
;;; init.el ends here
