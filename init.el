(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(tool-bar-mode -1)
(electric-indent-mode 1)
(require 'use-package)

(use-package hydra
  :defer t)

(use-package company
  :demand t
  :config (company-mode 1))

(use-package evil
  :demand t
  :config (progn (evil-mode 1)
		 (define-key evil-motion-state-map (kbd "SPC") nil)
		 (define-key evil-motion-state-map (kbd "SPC h") 'windmove-left)
		 (define-key evil-motion-state-map (kbd "SPC l") 'windmove-right)
		 (define-key evil-motion-state-map (kbd "SPC j") 'windmove-down)
		 (define-key evil-motion-state-map (kbd "SPC k") 'windmove-up)
		 (define-key evil-motion-state-map (kbd "SPC a") 'ivy-switch-buffer)
		 (define-key evil-motion-state-map (kbd "SPC q") 'kill-buffer-and-window)
		 (define-key evil-motion-state-map (kbd "SPC f") 'counsel-find-file)))
;; And a bit of configuration for dired on that front
(use-package dired
  :config (define-key dired-mode-map (kbd "SPC") nil))
;; Info as well
(define-key Info-mode-map (kbd "SPC") nil)
;; And compilation
(use-package compile
  :config (define-key compilation-mode-map (kbd "SPC") nil))


(use-package flatui-theme
  :demand t)

(use-package smartparens
  :defer t
  :bind (:map evil-motion-state-map
	      ("SPC s l" . sp-forward-slurp-sexp)
	      ("SPC s h" . sp-backward-barf-sexp)))

(use-package google-c-style
  :defer t
  :commands (google-set-c-style))

(use-package rainbow-delimiters
  :defer t)

(defun prog-minor-modes-common ()
  "Minor modes common to all programming."
  (interactive)
  (rainbow-delimiters-mode t)
  (paredit-mode t))

(add-hook 'emacs-lisp-mode-hook 'prog-minor-modes-common)

(use-package ivy
  :demand t
  :config (progn (setq ivy-re-builders-alist
		       '((t . ivy--regex-fuzzy)))
		 (ivy-mode 1)
		 (setq ivy-use-virtual-buffers t)
		 (setq enable-recursive-minibuffers t))
  :bind (("C-c C-r" . 'ivy-resume)
	 ("<f6>" . 'ivy-resume)))

(use-package ivy-hydra
  :after ivy)

(use-package swiper
  :demand t
  :bind ("C-s" . 'swiper))

(use-package counsel
  :demand t
  :bind (("M-x" . 'counsel-M-x)
	 ("C-x C-f" . 'counsel-find-file)
	 ("C-h f" . 'counsel-describe-function)
	 ("C-h v" . 'counsel-describe-variable)
	 ("C-c k" . 'counsel-ag)))

(use-package realgud
  :defer t)

(use-package meghanada
  :defer t
  :init (progn (add-hook 'java-mode-hook 
			 (meghanada-mode 1))
	  (add-hook 'meghanada-mode-hook
			  (lambda ()
			    (google-set-c-style)
			    (google-make-newline-indent)
			    (smartparens-mode 1)
			    (rainbow-delimeters-mode 1)
			    (setq indent-tabs-mode nil)
			    (setq tab-width 4)
			    (setq c-basic-offset 4)
			    (setq meghanada-server-remote-debug t)
			    (highlight-symbol-mode 1)))
	       (defhydra hydra-meghanada (:hint nil :exit t)
		 "
^Edit^                           ^Tast or Task^
^^^^^^-------------------------------------------------------
_f_: meghanada-compile-file      _m_: meghanada-restart
_c_: meghanada-compile-project   _t_: meghanada-run-task
_o_: meghanada-optimize-import   _j_: meghanada-run-junit-test-case
_s_: meghanada-switch-test-case  _J_: meghanada-run-junit-class
_v_: meghanada-local-variable    _R_: meghanada-run-junit-recent
_i_: meghanada-import-all        _r_: meghanada-reference
_g_: magit-status                _T_: meghanada-typeinfo
_l_: helm-ls-git-ls
_q_: exit
"
		 ("f" meghanada-compile-file)
		 ("m" meghanada-restart)

		 ("c" meghanada-compile-project)
		 ("o" meghanada-optimize-import)
		 ("s" meghanada-switch-test-case)
		 ("v" meghanada-local-variable)
		 ("i" meghanada-import-all)

		 ("g" magit-status)
		 ("l" helm-ls-git-ls)

		 ("t" meghanada-run-task)
		 ("T" meghanada-typeinfo)
		 ("j" meghanada-run-junit-test-case)
		 ("J" meghanada-run-junit-class)
		 ("R" meghanada-run-junit-recent)
		 ("r" meghanada-reference)

		 ("q" exit)
		 ("z" nil "leave")))
  :bind (:map meghanada-mode-map
	      ("C-c s" . hydra-meghanada/body))
  :commands (meghanada-mode))

(use-package geiser)

(use-package magit
  :defer t
  :bind (:map magit-mode-map
	      ("SPC" . nil)))

(use-package evil-magit
  :after magit)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(package-selected-packages
   (quote
    (evil-magit magit use-package smartparens realgud rainbow-identifiers rainbow-delimiters paredit nlinum meghanada lispy ivy-hydra google-c-style geiser flatui-theme evil counsel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
