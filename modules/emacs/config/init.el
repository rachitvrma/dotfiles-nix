;;; init.el --- Config for my Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; This is my personal Emacs configuration.

;;; Code:

;; Does what it says
(setq use-package-verbose t
      debug-on-error t)

(use-package emacs
  :init
  ;; "y or n" instead of typing out "yes"/"no" at every prompt.
  (setq use-short-answers t)
  (setq ring-bell-function 'ignore)

  :hook
  ;; Display line numbers in programming modes only
  (prog-mode . display-line-numbers-mode)
  ((prog-mode org-mode) . hl-line-mode)

  :custom
  ;; Don't litter every directory with foo~ backup files and
  ;; #foo#/.#foo lock files.
  (make-backup-files nil)
  (create-lockfiles nil)
  ;; Load the newer of a .el/.elc pair instead of silently running
  ;; stale byte-compiled code.
  (load-prefer-newer t)
  ;; Keep the point away from the extreme edges of the frame in
  ;; term/tty scenarios; harmless elsewhere.
  (scroll-margin 2)
  (scroll-conservatively 101)

  ;; VERTICO INTEGRATION

  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; Display relative line numbers
  (display-line-numbers-type 'relative)
  ;; Ensure the column doesn't aggresively jump in width as you scroll
  (display-line-numbers-width-start t)
  ;; Show the tab when there are more than one tab
  (tab-bar-show 1)

  :config
  ;; Redundant with the early-init default-frame-alist for the very
  ;; first frame, but this also covers any *later* frames (e.g. new
  ;; frames opened with emacsclient -c).
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1)
  (column-number-mode 1)


  ;; Quality-of-life editing defaults.
  (save-place-mode 1)           ; reopen files at the last visited line
  (recentf-mode 1)              ; track recently opened files (consult-buffer uses this)
  (global-auto-revert-mode 1)   ; pick up on-disk changes automatically
  (delete-selection-mode 1)     ; typing replaces an active region
  (electric-pair-mode 1)        ; auto-close brackets/quotes

  (global-visual-line-mode 1)   ; Enable softwrapping

  (setq-default indent-tabs-mode nil
                tab-width 4
                fill-column 80)

  ;; Keep Custom's own noisy auto-generated `(custom-set-variables ...)`
  ;; block out of this file entirely.
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (when (file-exists-p custom-file)
    (load custom-file 'noerror)))

(use-package elisp-mode
  :ensure nil
  :hook ((emacs-lisp-mode . flymake-mode)
         (emacs-lisp-mode . eldoc-mode)))   ; eldoc's on by default but explicit here is harmless

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package no-littering
  :demand t
  :config
  ;; no-littering's own README recipe: auto-save files still need an
  ;; explicit redirect, everything else it handles on its own.
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

(use-package dashboard
  :init
  (setq dashboard-startup-banner 'logo
        initial-buffer-choice #'dashboard-open
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-navigation-cycle t

        ;; Nerd icons
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        ;; Show shortcuts
        dashboard-show-shortcuts t)
  :config
  (add-hook 'server-after-make-frame-hook #'dashboard-open)
  (dashboard-setup-startup-hook))

(use-package page-break-lines
  :init
  (page-break-lines-mode))

(use-package doom-modeline
  :after nerd-icons
  :init (doom-modeline-mode 1)
  :custom
  ;; doom-modeline--generate-clock caches the live clock SVG in a
  ;; single global variable (keyed by minute, not by frame), and by
  ;; default sizes it as (* doom-modeline-height 0.5
  ;; doom-modeline-time-clock-size). Under emacsclient/services.emacs
  ;; that comes out wrong -- whichever frame's doom-modeline-height
  ;; happens to be in effect when the per-minute cache regenerates
  ;; sets the size for every frame until the next minute. Per the
  ;; source, an *integer* doom-modeline-time-clock-size is used
  ;; directly as the pixel radius instead, bypassing
  ;; doom-modeline-height (and this whole cache-consistency issue)
  ;; entirely, while keeping the live icon everywhere.
  (doom-modeline-time-clock-size 9)
  :config
  (display-time-mode 1)
  (display-battery-mode 1))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;; Adds icons to grep/rg/ripgrep-style result buffers (e.g. consult-grep).
(use-package nerd-icons-grep
  :after grep)

(use-package nerd-icons-xref
  :after xref
  :config
  (nerd-icons-xref-mode 1))

;; marginalia annotates minibuffer completions (file/buffer lists,
;; M-x, etc.); this adds an icon per candidate to those annotations.
(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-fd)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  (eval-when-compile (require 'consult))
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode))

(use-package eglot
  :hook ((nix-ts-mode
          bash-ts-mode
          c-ts-mode
          c++-ts-mode
          python-ts-mode
          html-mode
          html-ts-mode
          css-ts-mode
          js-ts-mode
          json-ts-mode
          yaml-ts-mode
          tex-mode
          LaTeX-mode
          toml-ts-mode
          scheme-mode) . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l r" . eglot-rename)
              ("C-c l d" . eldoc)
              ("C-c l R" . eglot-reconnect)
              ("C-c l q" . eglot-shutdown)
              ("C-c l h" . eglot-inlay-hints-mode)
              )
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  :config
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nixd" "--semantic-tokens=true" "--inlay-hints=false")))
  (add-to-list 'eglot-server-programs
               '(scheme-mode . ("guile-lsp-server"))))

(use-package apheleia
  :init
  (apheleia-global-mode 1)
  :config
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'nixfmt)
  ;; Universal fallback: Wire web and config languages to Dprint
  (dolist (mode '(html-mode html-ts-mode css-ts-mode js-ts-mode
                            json-ts-mode toml-ts-mode yaml-ts-mode markdown-mode))
    (setf (alist-get mode apheleia-mode-alist) 'dprint)))

;; Tree-sitter grammars
(use-package treesit
  :config
  (setq major-mode-remap-alist
        '((sh-mode         . bash-ts-mode)
          (c-mode          . c-ts-mode)
          (c++-mode        . c++-ts-mode)
          (python-mode     . python-ts-mode)
          (css-mode        . css-ts-mode)
          (javascript-mode . js-ts-mode)
          (js-mode         . js-ts-mode)
          (json-mode       . json-ts-mode)
          (yaml-mode       . yaml-ts-mode)
          (toml-mode       . toml-ts-mode))))

;; nix-ts-mode isn't remapping a built-in mode the way bash-ts-mode
;; remaps sh-mode -- there's no built-in "nix-mode" in Emacs at all --
;; so it's registered directly against the file extension instead.
(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package json-ts-mode
  :mode "\\.json\\'")

(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package majutsu
  :after magit
  :bind ("C-x j" . majutsu))

(use-package emms
  :commands (emms emms-play-directory-tree)
  :init
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  :custom
  (emms-source-file-default-directory "~/Music/"))

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("--" "---" "==" "===" "!=" "!==" "=!="
                                       "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                                       "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                                       "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                                       "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                                       "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                                       "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                                       "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                                       "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                                       "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                                       "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                                       ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                                       "<:<" ";;;"))
  (global-ligature-mode t))

(use-package zoxide
  :bind ("C-c z" . zoxide-travel))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches "-algho --group-directories-first")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  :hook (dired-mode . dired-hide-details-mode)
  :bind (:map dired-mode-map
              (";" . dired-up-directory)
              ("." . dired-omit-mode)))

(use-package dired-x
  :ensure nil
  :hook (dired-mode . dired-omit-mode)
  :custom
  (dired-omit-files "^\\."))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-expert t)
  (ibuffer-default-sorting-mode 'filename/process)
  (ibuffer-formats
   '((mark modified read-only locked " "
           (name 30 30 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename)))

  :hook
  (ibuffer-mode . (lambda () (ibuffer-switch-to-saved-filter-groups "default")))

  :config
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Org Agenda" (mode . org-agenda-mode))
           ("Org"        (mode . org-mode))
           ("News"       (or (name . "^\\*newsticker")
                             (predicate . (derived-mode-p 'newsticker-mode
                                                          'newsticker-treeview-mode))))
           ("Mail"       (or (predicate . (derived-mode-p 'mu4e-headers-mode
                                                          'mu4e-view-mode
                                                          'mu4e-main-mode))
                             ;; swap the above for notmuch-/gnus- modes if that's
                             ;; what you're actually running with himalaya
                             ))
           ("Web"        (or (mode . eww-mode)
                             (mode . xwidget-webkit-mode)))
           ("EMMS"       (predicate . (derived-mode-p 'emms-playlist-mode
                                                      'emms-browser-mode
                                                      'emms-stream-mode)))
           ("VCS"        (or (predicate . (derived-mode-p 'magit-mode))
                             (mode . vc-dir-mode)
                             ;; add your jujutsu client's mode symbol here once
                             ;; confirmed — unsure of its exact name
                             ))
           ("Dired"      (mode . dired-mode))
           ("IRC"        (or (mode . erc-mode)
                             (mode . rcirc-mode)))
           ("Ement"      (or (predicate . (derived-mode-p 'ement-room-mode
                                                          'ement-room-list-mode
                                                          'ement-directory-mode))
                             (name . "^\\*Ement")))
           ("Files"      (predicate . (and (buffer-file-name)
                                           (not (derived-mode-p 'dired-mode)))))
           ("Special"    (name . "^\\*"))))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package indent-bars
  :hook (prog-mode . indent-bars-mode))

(use-package breadcrumb
  :config
  (breadcrumb-mode 1))

(use-package pulsar
  :bind
  (:map global-map
        ("C-x l" . pulsar-pulse-line)
        ("C-x L" . pulsar-highlight-permanently-dwim))
  :init
  (pulsar-global-mode 1)
  :hook
  ((next-error . pulsar-pulse-line)

   ;; Imenu integration
   (imenu-after-jump . pulsar-recenter-top)
   (imenu-after-jump . pulsar-reveal-entry)

   (minibuffer-setup . pulsar-pulse-line)

   ;; Consult
   (consult-after-jump . pulsar-recenter-top)
   (consult-after-jump . pulsar-reveal-entry)))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom
  ;; Mapped specifically to the Colemak-DH home row
  (aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))
  (aw-scope 'frame))

;; which-key is built into Emacs 30
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :ensure nil
  :config
  (which-key-mode 1))

(use-package aria2
  :defer t)

(use-package ispell
  :ensure nil
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "en")
  (ispell-extra-args '("--add-extra-dicts=en-computers.rws"
                       "--add-extra-dicts=en_US-science.rws")))

;; Enable flyspell for markdown and org buffers
(use-package flyspell
  :ensure nil
  :hook (org-mode . flyspell-mode))

(use-package project
  :ensure nil
  :bind (:map project-prefix-map
              ("m" . magit-project-status)
              ("r" . consult-ripgrep))
  :custom
  ;; Recognize Flake directories as project roots even if they are not yet initialized in Git
  (project-vc-extra-root-markers '("flake.nix"))

  ;; Define the dispatch menu that appears when switching projects (C-x p p)
  (project-switch-commands
   '((project-find-file "Find file" ?f)
     (project-dired "Dired" ?d)
     (magit-project-status "Magit status" ?m)
     (consult-ripgrep "Search (ripgrep)" ?r)
     (project-find-dir "Find directory" ?D)
     (project-kill-buffers "Kill project buffers" ?k))))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult) ; only need to install it, embark loads it after consult if found

;; Enable pass integration so Emacs can read your ~/.password-store natively
(use-package auth-source-pass
  :ensure nil
  :config
  (auth-source-pass-enable))

(defun my/erc-soju-libera ()
  (interactive)
  (erc :server "127.0.0.1"
       :port 6667
       :nick "woodenAllen"
       :user "woodenAllen/libera"
       :password (auth-source-pass-get 'secret "irc/soju")))

(use-package erc
  :ensure nil
  :bind (("C-c e l" . my/erc-soju-libera))
  :custom
  (erc-server-reconnect-attempts 5)
  (erc-server-reconnect-timeout 3)
  (erc-autojoin-channels-alist
   '(("Libera.Chat" "#nixos" "#emacs"))))

(use-package rcirc
  :ensure nil
  :init
  (setq rcirc-server-alist
        `(("127.0.0.1"
           :port 6667
           :encryption plain
           :nick "woodenAllen"
           :user-name "woodenAllen/libera"
           :password ,(auth-source-pass-get 'secret "irc/soju")))))

(use-package ement
  :custom
  (ement-save-sessions t)
  (ement-save-sessions-file (expand-file-name "ement-sessions.el" user-emacs-directory)))

(use-package newsticker
  :ensure nil
  :bind ("C-c n" . newsticker-treeview)
  :custom
  ;; Fetch updates automatically in the background every hour (3600 seconds)
  (newsticker-retrieval-interval 3600)

  ;; Keep the mode-line clean by not showing the scrolling headline ticker
  (newsticker-display-interval nil)

  ;; --- Cleanup & Cache Control ---
  ;; Delete items from Emacs storage once they are marked obsolete/old
  (newsticker-keep-obsolete-items nil)
  ;; Absolute fail-safe: force-delete unread articles after 14 days
  (newsticker-obsolete-item-max-age (* 14 24 60 60))

  ;; Define your feeds: '("Title" "URL")
  (newsticker-url-list
   '(
     ("Noctalia" "https://noctalia.dev/rss.xml")
     ("Drew Devault's Blog" "https://drewdevault.com/blog/index.xml")
     ("Fedora Magazine" "https://fedoramagazine.org/feed/")
     ("FreeCodeCamp Blogs" "https://www.freecodecamp.org/news/tag/blog/rss/")
     ("FreeCodeCamp News" "https://www.freecodecamp.org/news/rss")
     ("FreeCodeCamp Programming Blogs" "https://www.freecodecamp.org/news/tag/programming-blogs/rss/")
     ("Home Manager News" "https://techhub.social/@hmnews.rss")
     ("Ian Henry's Blog" "https://ianthehenry.com/feed.xml")
     ("Redhat Blog" "https://www.redhat.com/en/rss/blog")
     ("Simon Willison's Blog" "https://simonwillison.net/atom/everything/")
     ("Mini Nvim" "https://nvim-mini.org/blog/index.xml")
     ("Neovim News" "https://neovim.io/news.xml")
     ("Neovim Plugins" "https://dotfyle.com/neovim/plugins/rss.xml")
     ("Neovim Releases" "https://github.com/neovim/neovim/releases.atom")
     ("r/neovim" "https://www.reddit.com/r/neovim.rss")
     ("This Week In Neovim Dotfyle" "https://dotfyle.com/this-week-in-neovim/rss.xml")
     ("NixOS discourse (announcements)" "https://discourse.nixos.org/latest.rss")
     ("NixOS Discourse (Announcements)" "https://discourse.nixos.org/c/announcements/8.rss")
     ("https://krebsonsecurity.com/feed/" "https://krebsonsecurity.com/feed/")
     ("The Hacker News" "https://feeds.feedburner.com/TheHackersNews")
     ("GNU Guix Blog" "https://guix.gnu.org/feeds/blog.atom")
     ))

  :config
  ;; Start the background retrieval process automatically
  (newsticker-start t))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         ;; Show git statuses in Dired buffers too
         (dired-mode . diff-hl-dired-mode)
         ;; Sync automatically with Magit/Majutsu actions
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; Calculate diffs live as you type, without needing to save the file
  (diff-hl-flydiff-mode 1)

  ;; By default, Emacs puts these signs in the graphical "Fringe".
  ;; Uncomment the line below if you prefer them shifted inward
  ;; to sit flush against the line numbers (closer to the Neovim look).
  ;; (diff-hl-margin-mode 1)
  )

(use-package org
  :ensure nil
  :commands (org-capture org-agenda)
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture))

  :custom
  (org-directory "~/org")
  (org-agenda-files (list org-directory))
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
      "* TODO %?\n  %U\n  %i\n  %a"
      :empty-lines 1)
     ("j" "Journal" entry
      (file+olp+datetree "~/org/journal.org")
      "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
      :empty-lines 1)
     ("n" "Note" entry (file+headline org-default-notes-file "Notes")
      "* %?\n  %i\n  %a")))

  :hook
  (org-mode . org-indent-mode)
  (org-mode . variable-pitch-mode)

  :config
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("nix" . "src nix")))

(use-package helpful
  :bind(
  ("C-h f" . helpful-callable)
  ("C-h v" . helpful-variable)
  ("C-h k" . helpful-key)
  ("C-h x" . helpful-command)
  ("C-h C-d" . helpful-at-point)
  ("C-h F" . helpful-function)))

(use-package hl-todo
  :config
  (global-hl-todo-mode))

;; Use consult-todo with hl-todo
(use-package consult-todo
  :demand t
  :config
  ;; Use narrows with consult-todo
  (defconst consult-todo--narrow
    '((?t . "TODO")
      (?f . "FIXME")
      (?b . "BUG")
      (?h . "HACK"))
    "Default mapping of narrow and keywords."))

(use-package pomo-cat
  :custom
  (pomo-cat-use-dedicated-frame t))

(use-package xdg-launcher)

(use-package colorful-mode
  :custom
  (colorful-use-prefix t)
  ;; (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

(use-package direnv
  :config
  (direnv-mode))

(use-package doom-themes
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-neotree-file-icons t) ; Use nerd-icons in neotree
  :config
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package neotree
  :bind ("C-c t" . neotree-toggle))

(use-package exec-path-from-shell
  :config
  (when (or (memq window-system '(mac ns x pgtk))
            (daemonp))
    (exec-path-from-shell-copy-envs '("GNUPGHOME" "GPG_TTY" "SSH_AUTH_SOCK"))
    (exec-path-from-shell-initialize)))

(use-package undo-fu
  :ensure t
  :bind

  (("C-z"   . undo-fu-only-undo)
   ("C-S-z" . undo-fu-only-redo)))

(use-package undo-fu-session
  :ensure t
  :after undo-fu
  :custom
  (undo-fu-session-linear t)
  :config
  (undo-fu-session-global-mode))

(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))

(use-package avy
  :bind (("C-:" . avy-goto-char)
         ("M-g w" . avy-goto-word-1)
         ("M-g W" . avy-goto-subword-1))
  :custom
  (avy-all-windows t))

(use-package avy-zap
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

(use-package avy-embark-collect
  :after embark)

(use-package tex
  :ensure auctex
  :defer t
  :hook (LaTeX-mode . turn-on-reftex)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  (TeX-command-default "LatexMk")
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server t)
  (TeX-view-program-selection '((output-pdf "Zathura")))
  (TeX-view-program-list
   '(("Zathura" "zathura --synctex-forward %n:0:%b %o" "zathura"))))


(use-package cdlatex
  :after tex
  :hook (LaTeX-mode . turn-on-cdlatex))

(provide 'init)
;;; init.el ends here
