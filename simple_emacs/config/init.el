;;; init.el --- Initial configuration -*- lexical-binding: t; -*-

(require 'evil)
(require 'general)
(require 'nix-mode)
(require 'vterm)
(require 'ivy)
(require 'counsel)
(require 'magit)
(require 'dash)

(load-theme #'modus-vivendi)

;; NOTE: In Emacs :height is 1/10pt, so 120 => 12pt, 140 => 14pt
(set-face-attribute 'default nil :family "Berkeley Mono" :height 140)

;; Disable bold/italics
(-map (lambda (x)
        (set-face-attribute x nil :slant 'normal :weight 'normal))
      (face-list))

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default truncate-lines t)
(setq scroll-step 1)
(setq dired-listing-switches "-al --group-directories-first")
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq initial-buffer-choice (format "%s/programming/base" (getenv "HOME")))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(evil-mode 1)
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
 "-" #'dired-up-directory
 "f" #'project-find-file)

(general-define-key
 :states 'normal
 :prefix "SPC"
 "w" #'save-buffer
 "f" #'project-find-file
 "b" #'counsel-switch-buffer
 "k" #'kill-buffer
 "I" #'ibuffer
 "gs" #'magit-status
 "ee" '(lambda () (interactive) (find-file "~/programming/dotfiles/simple_emacs/config/init.el"))
 "jb" '(lambda () (interactive) (find-file "~/programming/base"))
 "jd" '(lambda () (interactive) (find-file "~/programming/dotfiles")))

(evil-set-initial-state 'vterm-mode 'insert)
(global-set-key (kbd "C-s-t")
                (lambda ()
                  (interactive)
                  (if (eq 'vterm-mode
                          (with-current-buffer (current-buffer) major-mode))
                      (->> (buffer-list)
                           (-find (lambda (x) (not (eq 'vterm-mode (with-current-buffer x major-mode)))))
                           (switch-to-buffer))
                    (vterm))))

(general-define-key
 :keymaps 'vterm-mode-map
 "M-:" nil
 "M--" #'evil-window-split
 "M-\\" #'evil-window-vsplit
 "C-S-n" '(lambda ()
            (interactive)
            (vterm (format "*vterm-%d*"
                           (-count (lambda (x)
                                     (eq 'vterm-mode (with-current-buffer x major-mode)))
                                   (buffer-list))))))

(general-define-key
 :keymaps 'override
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

(provide 'init)
;;; init.el ends here
