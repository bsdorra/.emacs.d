(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(compilation-message-face (quote default))
 '(helm-source-names-using-follow (quote ("RTags Helm" "Find tag from here")))
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(mark-ring-max 64)
 '(package-selected-packages
   (quote
	(ggtags rtags yasnippet which-key wgrep web-mode visible-mark use-package swoop smooth-scroll smartscan smart-tabs-mode smart-tab python-mode pug-mode paradox ox-jira org-jira ob-ipython nyan-mode multiple-cursors monokai-theme markdown-mode magit json-mode jabber iedit helm-swoop helm-projectile helm-package helm-gtags helm-company helm-ag gtags flycheck expand-region exec-path-from-shell esup company-jedi company-irony cmake-mode auto-highlight-symbol)))
 '(safe-local-variable-values
   (quote
	((projectile-project-compilation-cmd . "cmake --build .build --target p2studio --config RelWithDebInfo")
	 (projectile-project-run-cmd . "\".build/RelWithDebInfo/p2studio.exe\"")
	 (projectile-project-compilation-cmd . "cmake .build --target p2studio --config RelWithDebInf")
	 (projectile-project-run-cmd . ".build/RelWithDebInfo/p2studio.exe")
	 (projectile-run-project . ".build/RelWithDebInfo/p2studio.exe")
	 (projectile-project-compilation-cmd . "cmake .build --target p2studio --config RelWithDebInfo"))))
 '(scroll-bar-mode nil)
 '(send-mail-function (quote mailclient-send-it))
 '(set-mark-command-repeat-pop t))


;;----------------------------------------------------------------------------
;; General Settings
;;----------------------------------------------------------------------------
(setq debug-on-error nil)
(server-start)			  
;;(load "server")
;;(unless (server-running-p) (server-start))

(defvar is-mac (equal system-type 'darwin))
(defvar is-win (equal system-type 'windows-nt))
(defvar is-linux (string-equal system-type "gnu/linux"))

(when is-mac
  (set-frame-font "-apple-Monaco-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1")
  (setq mac-command-modifier 'meta)) ;; set cmd key to alt
(when is-win
  (set-frame-font "DejaVu Sans Mono-8" nil t))
  ;;(set-frame-font "Lucida Sans Unicode-10" nil t))

;; start size
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(semantic-mode t) 
(global-linum-mode t) ;; show line numbers
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq column-number-mode t);; enable column numbers
(setq fill-column 80)
(setq ns-pop-up-frames nil) ;; no new frame for file opened from finder
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
(defvar python-shell-prompt-detect-failure-warning nil) ;; hack, gets rid of weird warning message on file load
;; (defvar compilation-auto-jump-to-first-error t)
(setq compilation-scroll-output t)
(defalias 'yes-or-no-p 'y-or-n-p) ;; confirm with y instead of yes<ret>
(setq desktop-save-mode t)
(show-paren-mode t) ;; show matching brackets
(delete-selection-mode t) ;; replace selection on typing or yank
(global-auto-revert-mode) ;; auto update buffer changed on disk
(setq ring-bell-function 'ignore)
(setq gdb-many-windows t) ;; use gdb-many-windows by default
;; (setq gdb-show-main t) ;; Non-nil means display source file containing the main routine at startup
(electric-pair-mode t) ;; auto closing brackets/parens
;; make electric-pair-mode work on more brackets
(defvar electric-pair-pairs '((?\" . ?\")
			      (?\{ . ?\})
			      (?\' . ?\')
			      ))
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(global-visual-line-mode)


;;----------------------------------------------------------------------------
;; Emacs config
;;----------------------------------------------------------------------------
(defun config () (interactive) (find-file "~/.emacs.d/init.el"))
(defun reload-config ()
  "reload your .emacs file without restarting Emacs"
  (interactive)							
  (load-file "~/.emacs.d/init.el"))

(defun commit-and-push-config ()
  (interactive)
  (shell-command
   "git commit init.el -m\"auto commit config change\" && git push origin master"
   ))


;;----------------------------------------------------------------------------
;; Packages
;;----------------------------------------------------------------------------
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; (use-package auctex
;;   :ensure t)

(use-package auto-highlight-symbol
  ;;:disabled
  :config
  (global-auto-highlight-symbol-mode))

(use-package cmake-mode
  :mode
  ("CMakeLists\\.txt\\'" . cmake-mode)
  ("\\.cmake\\'" . cmake-mode))


(use-package company
  ;;:diminish company-mode
  :config
  (company-mode)
  (global-company-mode)
  ;;(company-quickhelp-mode)
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (setq company-dabbrev-downcase case-replace)
  (setq company-idle-delay 1)
  (when is-mac(push 'company-rtags company-backends))
  (use-package company-irony
  	:ensure t
  	:config
  	(add-to-list 'company-backends 'company-irony)
	;; replace the `completion-at-point' and `complete-symbol' bindings in
	;; irony-mode's buffers by irony-mode's function
	(defun my-irony-mode-hook ()
	  (define-key irony-mode-map [remap completion-at-point]
		'irony-completion-at-point-async)
	  (define-key irony-mode-map [remap complete-symbol]
		'irony-completion-at-point-async))
	(add-hook 'irony-mode-hook 'my-irony-mode-hook)
	(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
  (use-package company-jedi
	;;:disabled
    :config
    (add-to-list 'company-backends 'company-jedi)
	(defun my/python-mode-hook ()
	  (add-to-list 'company-backends 'company-jedi)	  
	  ;(add-hook 'python-mode-hook 'run-python-internal)
	  )
	(add-hook 'python-mode-hook 'my/python-mode-hook)))


(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
	(exec-path-from-shell-initialize)))

(use-package expand-region)


(use-package flycheck
  :disabled  
  :config
  (global-flycheck-mode)
  (add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++14")))
  (add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++14"))))
  ;;(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

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
   ("C-i" . helm-execute-persistent-action)
   ("C-z" .  helm-select-action))
  :config
  (helm-mode)
  (define-key helm-map [tab] 'helm-execute-persistent-action)
  (use-package helm-package)
  (use-package helm-projectile
  	:config
  	(helm-projectile-on)) 
  (use-package helm-swoop
	:bind ("M-i" . helm-swoop))
  (use-package helm-ag)
  (setq helm-split-window-in-side-p nil
		helm-mode-fuzzy-match t
		helm-completion-in-region-fuzzy-match t
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
		))


(use-package iedit)

;; fallback from rtags to irony on windows system
(use-package irony
  ;;:disabled
  :if is-win
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode))

(use-package magit
  :bind ("C-x g" . magit-status)
  ;; :map magit-mode-map
  ;;  ([tab] . magit-section-toggle)))
  :config
  (if is-win
	  (setq magit-git-executable "C:\\Program Files\\Git\\bin\\git.exe")))
  
;; (setq jabber-invalid-certificate-servers '("jabber.ccc.de"))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package monokai-theme
  :config (load-theme 'monokai t))

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C->" . mc/mark-all-like-this))

(use-package nyan-mode)

(use-package org
  :commands(org-mode)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((octave . t)
	 (sh . t)
	 (python . t)
	 (emacs-lisp . t)   
	 ))
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
  (setq org-confirm-babel-evaluate nil))  

(use-package ob-ipython
  :defer)

(use-package ox-jira
  :defer)

(use-package paradox
  :defer)

(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-keymap-prefix (kbd "C-c p"))
  :config
  (projectile-mode t)
  (projectile-global-mode t)
  (setq projectile-completion-system 'helm
		projectile-indexing-method 'alien
		))

(use-package pug-mode 
  :config (setq tab-width 2)
  :mode ("\\.pug\\'" . pug-mode))

(use-package python-mode
  :disabled								
  :config
  (add-hook 'python-mode-hook
			(lambda ()			
			  (setq indent-tabs-mode t)
			  (setq py-indent-tabs-mode t)
			  (setq tab-width 4)
			  (setq python-indent 4))))

(use-package smartscan
  :defer t
  :config (global-smartscan-mode t))

(use-package smart-tab
  :init(global-smart-tab-mode))

(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'c++ 'c 'javascript 'python)
  (smart-tabs-advice py-indent-line py-indent-offset)
  (smart-tabs-advice py-newline-and-indent py-indent-offset)
  (smart-tabs-advice py-indent-region py-indent-offset)
  (smart-tabs-advice python-indent-line-1 python-indent)
  (add-hook 'python-mode-hook
			(lambda ()
			  (setq indent-tabs-mode t)
			  (setq indent-tabs-mode t)
			  (setq py-indent-tabs-mode t)
			  (setq tab-width 4)
			  (setq python-indent 4)
			  (setq tab-width (default-value 'tab-width)))))


(use-package swoop)

;; (use-package visible-mark)

;; (use-package wgrep)

(use-package which-key
  :config
  (which-key-mode))

(use-package yasnippet
  ;; :disabled
  ;;:diminish yas-minor-mode
  :commands
  (yas-minor-mode)
  :init
  ;; (setq yas-snippet-dirs "~/.emacs.d/snippets/" )
  :config
  (progn
	(yas-reload-all))
	(add-hook 'prog-mode-hook #'yas-minor-mode)
	(add-hook 'org-mode-hook  #'yas-minor-mode))


(use-package helm-gtags
  :defer
  ;;(setq helm-gtags-suggested-key-mapping t)
  ;;(setq helm-gtags-prefix-key "\C-t")
  ;;(setq helm-gtags-ignore-case t)
  :config
  (helm-gtags-mode)
  (setq helm-gtags-auto-update t)
  (when is-win (add-hook 'c-mode-common-hook 'helm-gtags-mode))
  (when is-win (add-hook 'c++-mode-common-hook 'helm-gtags-mode))
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  (add-hook 'javascript-mode-hook 'helm-gtags-mode))

(use-package rtags
  :if (not is-win)
  :init  
  (require 'rtags-helm)
  :config
  ;; install standard rtags keybindings. Do M-. on the symbol below to
  ;; jump to definition and see the keybindings.
  ;;(rtags-enable-standard-keybindings)
  (setq rtags-use-helm t)
  ;; company completion setup
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (when is-mac(add-hook 'c-mode-common-hook 'rtags-start-process-unless-running))
  (when is-mac(add-hook 'c++-mode-common-hook 'rtags-start-process-unless-running)))



;; handle tab behavior. decide between yas, indent or company complete
(defun check-expansion ()
  (save-excursion
	(if (looking-at "\\_>") t
	  (backward-char 1)
	  (if (looking-at "\\.") t
		(backward-char 1)
		(if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
	(yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
			(null (do-yas-expand)))
		(if (check-expansion)
			(company-complete-common-or-cycle)
		  (indent-for-tab-command)))))

(global-set-key [tab] 'tab-indent-or-complete)

;;----------------------------------------------------------------------------
;; RTags
;;----------------------------------------------------------------------------
(defun use-rtags (&optional useFileManager)
  (and (rtags-executable-find "rc")
       (cond ((not (gtags-get-rootpath)) t)
             ((and (not (eq major-mode 'c++-mode))
                   (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
             (useFileManager (rtags-has-filemanager))
             (t (rtags-is-indexed)))))

(defun tags-find-symbol-at-point (&optional prefix)
  (interactive "P")
  (if (or (not (use-rtags))
		  (and (not (rtags-find-symbol-at-point prefix)) rtags-last-request-not-indexed))
      (helm-gtags-find-tag-from-here)))

(defun tags-find-references-at-point (&optional prefix)
  (interactive "P")
  (setq tag (thing-at-point 'symbol))
  (if (or (not (use-rtags))
   		  (and (not (rtags-find-references-at-point prefix)) rtags-last-request-not-indexed))
       (helm-gtags-find-symbol tag)))

(defun tags-stack-back ()
  (interactive)
  (if (or (not (use-rtags))
		  (and (not (rtags-location-stack-back)) rtags-last-request-not-indexed))
      (helm-gtags-previous-history)))

(defun tags-stack-forward ()
  (interactive)
  (if (or (not (use-rtags))
		  (and (not (rtags-location-stack-forward)) rtags-last-request-not-indexed))
      (helm-gtags-next-history)))



;;----------------------------------------------------------------------------
;; C/C++ Mode 
;;----------------------------------------------------------------------------
(use-package cc-mode
  :bind
  ("<C-tab>" . company-complete)
  ("M-." . tags-find-symbol-at-point)
  ("M-," . tags-find-references-at-point)
  ("M-[" . tags-stack-back)
  ("M-]" . tags-stack-forward)
  ;;(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
  ;;(define-key c-mode-base-map (kbd "M-.") 'semantic-ia-fast-jump)
  :config
  (superword-mode)
  ;;(c-toggle-hungry-state 1) ;; A single <DEL> deletes all preceding whitespace
  ;;(c-toggle-auto-state 1) ;; Auto newline state
  
  )


(setq-default c-default-style "stroustrup"
			  c-basic-offset 4
			  tab-width 4)




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


(defadvice
    isearch-forward
    (after isearch-forward-recenter activate)
  (recenter))
(ad-activate 'isearch-forward)

(defadvice
    isearch-backward
    (after isearch-backward-recenter activate)
  (recenter))
(ad-activate 'isearch-backward)

(defadvice
    isearch-repeat-forward
    (after isearch-repeat-forward-recenter activate)
  (recenter))
(ad-activate 'isearch-repeat-forward)

(defadvice
    isearch-repeat-backward
    (after isearch-repeat-backward-recenter activate)
  (recenter))
(ad-activate 'isearch-repeat-backward)


;;;;=== Org Mode =======================================
(setq org-agenda-directory "~/org/")
(setq org-agenda-files (list org-agenda-directory));;(directory-files (expand-file-name org-agenda-directory) t "^[^\.][^#][[:alnum:]]+\.org$"))

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
(delete-selection-mode 1)

(setq org-list-demote-modify-bullet
      '(("+" . "-") ("-" . "+") ("*" . "+")))

(setq org-capture-templates
      '(("t" "Task" entry (file+headline org-default-notes-file "Inbox")
		 "* TODO %?\n")
		("n" "Note" entry (file+headline org-default-notes-file "Inbox")
		 "* NOTE %?\n")
		("j" "Journal" entry(file+datetree org-default-journal-file)
		 "* %?\n%T")	 ;; "* [%<%R>] %?\n")
		;; ("s" "Scheduled Task" entry (file+headline org-default-notes-file "Inbox")
		;;  "* SCHEDULED: %?\n%^t\n")
		;; ("d" "Done Task" entry (file+headline org-default-notes-file "Inbox")
		;;  "* DONE %?\nCLOSED: %U\n")
		;; ("n" "Next Task" entry (file+headline org-default-notes-file "Inbox")
		;;  "* NEXT %?\n")
		;; ("w" "Wait Task" entry (file+headline org-default-notes-file "Inbox")
		;;  "* WAIT %?\n")
		))

(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
		("DONE" . "green")
		("WAIT". "orange")
		("CANCELED" . (:foreground "magenta" :weight bold))
		;("NEXT" . "yellow")
		;("MAYBE" . "cyan")
		;("DELEGATED". "blue")
		))

;; Place tags close to the right-hand side of the window
(add-hook 'org-finalize-agenda-hook 'place-agenda-tags)
(defun place-agenda-tags ()
  "Put the agenda tags by the right border of the agenda window."
  (setq org-agenda-tags-column (- 4 (window-width)))
  (org-agenda-align-tags))



(defun unpop-to-mark-command ()
  "Unpop off mark ring into the buffer's actual mark.
Does not set point.  Does nothing if mark ring is empty."
  (interactive)
  (let ((num-times (if (equal last-command 'pop-to-mark-command) 2
                     (if (equal last-command 'unpop-to-mark-command) 1
                       (error "Previous command was not a (un)pop-to-mark-command")))))
    (dotimes (x num-times)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (+ 0 (car (last mark-ring))) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (mark t)))
      (deactivate-mark))))

(defun just-one-space-in-region (beg end)
  "replace all whitespace in the region with single spaces"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (re-search-forward "\\s-+" nil t)
        (replace-match " ")))))

(require 'rect)  
(defun just-one-space-in-rect-line (start end)
  (save-restriction
    (save-match-data
      (narrow-to-region (+ (point) start)
                        (+ (point) end))
      (while (re-search-forward "\\s-+" nil t)
        (replace-match " ")))))
(defun just-one-space-in-rect (start end)
  "replace all whitespace in the rectangle with single spaces"
  (interactive "r")
  (apply-on-rectangle 'just-one-space-in-rect-line start end))


;; .dir-locals stuff
(defun my-reload-dir-locals-for-current-buffer ()
  "reload dir locals for the current buffer"
  (interactive)
  (let ((enable-local-variables :all))
    (hack-dir-local-variables-non-file-buffer)))

(defun my-reload-dir-locals-for-all-buffer-in-this-directory ()
  "For every buffer with the same `default-directory` as the 
current buffer's, reload dir-locals."
  (interactive)
  (let ((dir default-directory))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (equal default-directory dir))
        (my-reload-dir-locals-for-current-buffer)))))

(add-hook 'emacs-lisp-mode-hook
          (defun enable-autoreload-for-dir-locals ()
            (when (and (buffer-file-name)
                       (equal dir-locals-file
                              (file-name-nondirectory (buffer-file-name))))
              (add-hook (make-variable-buffer-local 'after-save-hook)
                        'my-reload-dir-locals-for-all-buffer-in-this-directory)))) 



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

;;----------------------------------------------------------------------------
;; File mode association
;;----------------------------------------------------------------------------
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
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))


(defun switch-to-other-window-in-split ()
  (interactive)
  (other-window 1))

(advice-add 'split-window-right :after #'switch-to-other-window-in-split)

;;----------------------------------------------------------------------------
;; Keybindings
;;----------------------------------------------------------------------------
(global-set-key (kbd "C-x |") 'toggle-window-split)
;; (global-set-key (kbd "s-/") 'comment-dwim-line)
(global-set-key (kbd "M-;") 'comment-dwim-line) 

(global-set-key (kbd "C-.") 'er/expand-region)
(global-set-key (kbd "C-,") 'er/contract-region)


(global-set-key (kbd "C-c e") 'fc-eval-and-replace)
;; (global-set-key "\C-k" 'kill-whole-line)

(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 4)))
(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 4)))
;; (global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-x C-b") 'previous-buffer)
;; (global-set-key (kbd "C-M-SPC") 'highlight-symbol-next)
;; (global-auto-highlight-symbol-mode t)
;; (global-set-key (kbd "C-;") 'ahs-edit-mode)
;; (global-set-key (kbd "C-*") 'auto-highlight-symbol-mode)

(global-set-key (kbd "<f8>") 'recompile)
(global-set-key (kbd "<f9>") 'reload-config)
(global-set-key (kbd "<f10>") 'config)
(global-set-key (kbd "<f12>") 'commit-and-push-config)


(define-key global-map "\C-ct"
  (lambda () (interactive) (org-capture nil "t")))
(define-key global-map "\C-cj"
  (lambda () (interactive) (org-capture nil "j")))
(define-key global-map "\C-cn"
  (lambda () (interactive) (org-capture nil "n")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
