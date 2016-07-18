(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(company-quickhelp-mode t)
 '(compilation-message-face (quote default))
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(mark-ring-max 64)
 '(paradox-github-token t)
 '(scroll-bar-mode nil)
 '(set-mark-command-repeat-pop t))


(setq debug-on-error nil)
;;(server-start))
(load "server")
(unless (server-running-p) (server-start))

(setq is-mac (equal system-type 'darwin))
(setq is-win (equal system-type 'windows-nt))
(setq is-linux (string-equal system-type "gnu/linux"))

(when is-mac
	(set-frame-font "-apple-Monaco-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1"))
(when is-win
  (set-frame-font "DejaVu Sans Mono-8"))

;; start size
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(semantic-mode 1)
(global-linum-mode 1)
(menu-bar-mode 1)
(tool-bar-mode 0)
(setq fill-column 80)
(setq ns-pop-up-frames nil)
(setq-default ispell-program-name "aspell")
(setq next-line-add-newlines t) ;; C-n adds new lines at the end of the buffer
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(4 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq-default cursor-type 'bar)
(setq w32-pipe-read-delay 0)
(setq python-shell-prompt-detect-failure-warning nil) ;; hack, gets rid of weird warning message on file load
(setq compilation-auto-jump-to-first-error t)
(defalias 'yes-or-no-p 'y-or-n-p) ;; confirm with y instead of yes<ret>
(setq show-paren-mode t)

(require 'package)
(setq package-enable-at-startup nil)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
			 '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;; (use-package auctex
;;   :ensure t)

(use-package auto-complete)
;;(ac-config-default)

(use-package cmake-mode
  :config
  (setq auto-mode-alist
	(append '(("CMakeLists\\.txt\\'" . cmake-mode)
		  ("\\.cmake\\'" . cmake-mode))
		auto-mode-alist)))

(use-package company
  :diminish company-mode
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (use-package company-irony
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony))
  (use-package company-jedi
    :config
    (add-to-list 'company-backends 'company-jedi)))

(use-package flycheck
  :disabled
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; (require 'helm-config)
(use-package helm
  :diminish helm-mode
  :init
  (require 'helm-config)
  :bind
  (("C-c h" . helm-command-prefix)
  ("C-c h SPC" . helm-all-mark-rings)
   ("C-c h o" . helm-occur)
   ("C-c h x" . helm-register)
   ("M-x" . helm-M-x)
   ("C-x b" . helm-mini)
   ("C-x C-f" . helm-find-files)
   ("M-y" . helm-show-kill-ring)
  :map helm-map
	      ("[tab]" . helm-execute-persistent-action)
	      ("C-i" . helm-execute-persistent-action)
	      ("C-z" .  helm-select-action))
  :config
  (use-package helm-package)
  (use-package helm-projectile
	:config
	(helm-projectile-on))
  (use-package helm-swoop
	:bind ("M-i" . helm-swoop))
  (setq helm-mode 1
		helm-split-window-in-side-p nil
		helm-move-to-line-cycle-in-source t
		helm-ff-search-library-in-sexp t
		helm-scroll-amount 4
		helm-ff-file-name-history-use-recentf t
		helm-M-x-fuzzy-match t
		helm-buffers-fuzzy-matching t
		helm-recentf-fuzzy-match    t
		helm-semantic-fuzzy-match t
		helm-imenu-fuzzy-match t
		helm-follow-mode-persistent t
		;; helm-occur-init-source
		;; helm-buffer-list-init-source
		;; helm-attrset 'follow 1 helm-source-buffers-list
		;; helm-attrset 'follow 1 helm-source-occur
		))


(use-package iedit)

(use-package irony
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode))

 (use-package jedi
  :ensure t)

;; ;; Standard Jedi.el setting
;; ;; (add-hook 'python-mode-hook 'jedi:setup)
;; ;; (setq jedi:complete-on-dot t)


(use-package magit
  :bind
  ("C-x g" . magit-status))
  

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package monokai-theme
  :config (load-theme 'monokai t))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package nyan-mode)

(use-package org)

(use-package ob-ipython
  :config
  (setq org-confirm-babel-evaluate nil)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append))

(use-package ox-jira)

(use-package paradox)

(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-keymap-prefix (kbd "C-c p"))
  :config
  (projectile-mode t)
  (projectile-global-mode)
  (setq projectile-completion-system 'helm
		projectile-indexing-method 'alien
		))

(use-package python-mode
  :disabled
  :config
  (add-hook 'python-mode-hook
			(lambda ()
			  (setq indent-tabs-mode t)
			  (setq tab-width 4)
			  (setq py-indent-tabs-mode t)
			  ;; (add-to-list 'write-file-functions 'delete-trailing-whitespace)
			  (setq python-indent 4)
			  )))

(use-package smart-tabs-mode)

(use-package swoop)

(use-package wgrep)

(use-package which-key
  :config
  (setq which-key-mode t))

(use-package yasnippet
  ;; :disabled
  :diminish
  :commands(yas-minor-mode)
  :init
  ;; (setq yas-snippet-dirs "~/.emacs.d/snippets/" )
  (progn
	(add-hook 'prog-mode-hook #'yas-minor-mode)
	(add-hook 'org-mode-hook #'yas-minor-mode))
  :config
  (progn
	(yas-reload-all)))

(if is-win
	(setq magit-git-executable "C:\\Program Files\\Git\\bin\\git.exe"))


(global-set-key (kbd "C-c e") 'fc-eval-and-replace)
;; (global-set-key "\C-k" 'kill-whole-line)

(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 4)))
(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 4)))
(global-set-key (kbd "M-g") 'goto-line)

(require 'cc-mode)
;;;; Auto newline state
;; (add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))
;; A single <DEL> deletes all preceding whitespace
(add-hook 'c-mode-common-hook '(lambda () (c-toggle-hungry-state 1))
		  ;;(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
		  ;;(define-key c-mode-base-map (kbd "M-.") 'semantic-ia-fast-jump))
		  (define-key c-mode-base-map (kbd "M-.") 'semantic-ia-fast-jump));; (lambda(point) (interactive "d") (semantic-ia-fast-jump point))))
(add-hook 'c-mode-common-hook 'superword-mode)

(setq-default c-default-style "stroustrup"
	      c-basic-offset 4
	      tab-width 4)

(smart-tabs-insinuate 'c++ 'c 'javascript 'python)


(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))

(global-set-key "\C-y" 'yank-and-indent)

(add-hook 'text-mode-hook
	  (lambda ()
	    ;; lines are still defined by line-breaks, not display
	    (visual-line-mode 1)
	    (setq line-move-visual t)
	    ))

(add-to-list 'auto-mode-alist '("\\.fx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.inl\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mlc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.fp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.vp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hxx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))

(defun config () (interactive) (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f10>") 'config)

(defun reload-config ()
  "reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f9>") 'reload-config)

;; One line comments. Original idea from:
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command. If no region is
selected and current line is not blank and we are not at the end
of the line, then comment current line. Replaces default
behaviour of comment-dwim, when it inserts comment at the end of
the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(if is-mac
    (global-set-key (kbd "s-/") 'comment-dwim-line)
  (global-set-key (kbd "C-/") 'comment-dwim-line))



(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x |") 'toggle-window-split)


(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))


(defun buffer-menu-custom-font-lock  ()
  (let ((font-lock-unfontify-region-function
	 (lambda (start end)
	   (remove-text-properties start end '(font-lock-face nil)))))
    (font-lock-unfontify-buffer)
    (set (make-local-variable 'font-lock-defaults)
	 '(buffer-menu-buffer-font-lock-keywords t))
    (font-lock-fontify-buffer)))
(add-hook 'buffer-menu-mode-hook 'buffer-menu-custom-font-lock)


;; End incremental searches at the beginning of the search
(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
 (defun my-goto-match-beginning ()
      (when (and isearch-forward (not isearch-mode-end-hook-quit))
        (goto-char isearch-other-end)))
(defadvice isearch-exit (after my-goto-match-beginning activate)
  "Go to beginning of match."
  (when isearch-forward (goto-char isearch-other-end)))



;;;=== Org Mode =======================================
(setq org-agenda-directory "~/org/")
(setq org-agenda-files (list org-agenda-directory));;(directory-files (expand-file-name org-agenda-directory) t "^[^\.][^#][[:alnum:]]+\.org$"))

(define-key global-map "\C-cs"
        (lambda () (interactive) (org-capture nil "s")))
(define-key global-map "\C-cd"
        (lambda () (interactive) (org-capture nil "d")))
(define-key global-map "\C-ct"
        (lambda () (interactive) (org-capture nil "t")))
(define-key global-map "\C-cn"
        (lambda () (interactive) (org-capture nil "n")))
(define-key global-map "\C-cj"
        (lambda () (interactive) (org-capture nil "j")))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(define-key global-map "\C-cc" 'org-capture)

(add-to-list 'auto-mode-alist '("/.org/'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(setq org-log-done t)
(setq org-startup-indented 'enabled)
(setq org-startup-folded 'overview)
(setq org-default-notes-file "gtd.org")
(setq org-default-journal-file "~/org/journal.org")
(setq org-agenda-filter nil)
(setq org-blank-before-new-entry (quote ((heading) (plain-list-item))))
(setq org-outline-path-complete-in-steps t)
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 3))))
(setq org-refile-use-outline-path t)

(setq org-list-demote-modify-bullet
      '(("+" . "-") ("-" . "+") ("*" . "+")))

(setq org-capture-templates
      '(("t" "Task" entry (file+headline org-default-notes-file "Inbox")
	 "* TODO %?\n")
	("j" "Journal" entry(file+datetree org-default-journal-file)
	 "* %?\n%T")	 ;; "* [%<%R>] %?\n")
	("s" "Scheduled Task" entry (file+headline org-default-notes-file "Inbox")
	 "* SCHEDULED: %?\n%^t\n")
	("d" "Done Task" entry (file+headline org-default-notes-file "Inbox")
	 "* DONE %?\nCLOSED: %U\n")
	("n" "Next Task" entry (file+headline org-default-notes-file "Inbox")
	 "* NEXT %?\n")
	("w" "Wait Task" entry (file+headline org-default-notes-file "Inbox")
	 "* WAIT %?\n")))

(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
	("NEXT" . "yellow")
	("MAYBE" . "orange")
	("DONE" . "green")
	("WAITING". "cyan")
	("DELEGATED". "blue")
	("WAIT". "orange")
	("CANCELED" . (:foreground "magenta" :weight bold))))

;; Place tags close to the right-hand side of the window
(add-hook 'org-finalize-agenda-hook 'place-agenda-tags)
(defun place-agenda-tags ()
  "Put the agenda tags by the right border of the agenda window."
  (setq org-agenda-tags-column (- 4 (window-width)))
  (org-agenda-align-tags))


;; (defvar org-journal-file (concat org-dir "journal.org")
;;   "Path to OrgMode journal file.")
;; (defvar org-journal-date-format "%Y-%m-%d"
;;   "Date format string for journal headings.")

;; (defun org-journal-entry ()
;;   "Create a new diary entry for today or append to an existing one."
;;   (interactive)
;;   (switch-to-buffer (find-file org-journal-file))
;;   (widen)
;;   (let ((isearch-forward t) (today (format-time-string org-journal-date-format)))
;;     (((lambda ()
;;          (org-insert-heading)
;;          (insert today)
;;          (insert "\n\n  \n"))))
;;     (beginning-of-buffer)
;;     (org-show-entry)
;;     (org-narrow-to-subtree)
;;     (end-of-buffer)
;;     (backward-char 2)
;;     (unless (= (current-column) 2)
;;       (insert "\n\n  "))))


;; ;;Disable C-c [ and C-c ] in org-mode
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             ;; Undefine C-c [ and C-c ] since this breaks my
;;             ;; org-agenda files when directories are include It
;;             ;; expands the files in the directories individually
;;             (org-defkey org-mode-map "\C-c["    'undefined)
;;             (org-defkey org-mode-map "\C-c]"    'undefined))
;;           'append)


;; ;;================================================================================

;; (defvar semantic-tags-location-ring (make-ring 20))

;; (defun semantic-goto-definition (point)
;;   "Goto definition using semantic-ia-fast-jump
;; save the pointer marker if tag is found"
;;   (interactive "d")
;;   (condition-case err
;;       (progn
;;         (ring-insert semantic-tags-location-ring (point-marker))
;;         (semantic-ia-fast-jump point))
;;     (error
;;      ;;if not found remove the tag saved in the ring
;;      (set-marker (ring-remove semantic-tags-location-ring 0) nil nil)
;;      (signal (car err) (cdr err)))))

;; (defun semantic-pop-tag-mark ()
;;   "popup the tag save by semantic-goto-definition"
;;   (interactive)
;;   (if (ring-empty-p semantic-tags-location-ring)
;;       (message "%s" "No more tags available")
;;     (let* ((marker (ring-remove semantic-tags-location-ring 0))
;;               (buff (marker-buffer marker))
;;                  (pos (marker-position marker)))
;;       (if (not buff)
;;             (message "Buffer has been deleted")
;;         (switch-to-buffer buff)
;;         (goto-char pos)
;; 	(recenter-top-bottom))
;;       (set-marker marker nil nil))))

;; (global-set-key (kbd "M-.") 'semantic-goto-definition)
;; (global-set-key (kbd "M-*") 'semantic-pop-tag-mark)


;;(add-hook 'python-mode-hook 'my/python-mode-hook)

;; ;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)



;; (global-auto-highlight-symbol-mode t)
;; (global-set-key (kbd "C-;") 'ahs-edit-mode)
;; (global-set-key (kbd "C-*") 'auto-highlight-symbol-mode)


;; (defun increment-number-at-point (&optional amount)
;;   "Increment the number under point by `amount'"
;;   (interactive "p")
;;   (let ((num (number-at-point)))
;;     (when (numberp num)
;;       (let ((newnum (+ num amount))
;;          (p (point)))
;;     (save-excursion
;;       (skip-chars-backward "-.0123456789")
;;       (delete-region (point) (+ (point) (length (number-to-string num))))
;;       (insert (number-to-string newnum)))
;;     (goto-char p)))))

;; ;; (defun decrement-number-at-point (&optional amount)
;; ;;   (interactive "p")
;; ;;   "Decrement the number under point by `amount'"
;; ;;   (increment-number-at-point (- (abs amount))))

;; ;; (define-key global-map [up] 'increment-number-at-point)
;; ;; (define-key global-map [down] 'decrement-number-at-point)

;; (defun unpop-to-mark-command ()
;;   "Unpop off mark ring into the buffer's actual mark.
;; Does not set point.  Does nothing if mark ring is empty."
;;   (interactive)
;;   (let ((num-times (if (equal last-command 'pop-to-mark-command) 2
;;                      (if (equal last-command 'unpop-to-mark-command) 1
;;                        (error "Previous command was not a (un)pop-to-mark-command")))))
;;     (dotimes (x num-times)
;;       (when mark-ring
;;         (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
;;         (set-marker (mark-marker) (+ 0 (car (last mark-ring))) (current-buffer))
;;         (when (null (mark t)) (ding))
;;         (setq mark-ring (nbutlast mark-ring))
;;         (goto-char (mark t)))
;;       (deactivate-mark))))
;; (global-set-key (kbd "C-M-SPC") 'highlight-symbol-next)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
