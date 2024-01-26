{ config, pkgs, ... }:

{
  services.emacs.startWithUserSession = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [ use-package ivy all-the-icons doom-modeline doom-themes rainbow-delimiters which-key ivy-rich counsel helpful general rustic lsp-mode lsp-ui company yasnippet lsp-java flycheck ];
    extraConfig = ''
      ;; (setq inhibit-startup-message t)
      
      (scroll-bar-mode -1)        ; Disable visible scrollbar
      (tool-bar-mode -1)          ; Disable toolbar
      (tooltip-mode -1)           ; Disable tooltips
      (set-fringe-mode 5)        ; Make it comfy
      
      (menu-bar-mode -1)            ; Disable the menu bar
      
      ;; Set up the visible bell
      (setq visible-bell t)
      
      (set-face-attribute 'default nil :font "JuliaMono" :height 120)
      (setq default-frame-alist '((font . "JuliaMono")))
      
      ;; Make ESC quit prompts
      (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
      
      ;; Initialize package sources
      (require 'package)
      
      (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                               ("org" . "https://orgmode.org/elpa/")
                               ("elpa" . "https://elpa.gnu.org/packages/")))
      
      (package-initialize)
      (unless package-archive-contents
       (package-refresh-contents))
      
      ;; Initialize use-package on non-Linux platforms
      (unless (package-installed-p 'use-package)
         (package-install 'use-package))
      
      (require 'use-package)
      (setq use-package-always-ensure t)
      
      (column-number-mode)
      (global-display-line-numbers-mode t)
      
      ;; Disable line numbers for some modes
      (dolist (mode '(org-mode-hook
        term-mode-hook
        shell-mode-hook
        eshell-mode-hook))
        (add-hook mode (lambda () (display-line-numbers-mode 0))))
      
      (use-package ivy
        :diminish
        :bind (("C-s" . swiper)
               :map ivy-minibuffer-map
               ("TAB" . ivy-alt-done) 
               ("C-l" . ivy-alt-done)
               ("C-j" . ivy-next-line)
               ("C-k" . ivy-previous-line)
               :map ivy-switch-buffer-map
               ("C-k" . ivy-previous-line)
               ("C-l" . ivy-done)
               ("C-d" . ivy-switch-buffer-kill)
               :map ivy-reverse-i-search-map
               ("C-k" . ivy-previous-line)
               ("C-d" . ivy-reverse-i-search-kill))
        :config
        (ivy-mode 1))
      
      ;; First time on a new system will require running
      ;; the following interactively
      ;;
      ;; M-x all-the-icons-install-fonts
      
      (use-package all-the-icons)
      
      (use-package doom-modeline
        :init (doom-modeline-mode 1)
        :custom (doom-modeline-height 30))
      
      (use-package doom-themes
        :init (load-theme 'doom-material-dark t))
      
      (use-package rainbow-delimiters
        :hook (prog-mode . rainbow-delimiters-mode))
      
      (use-package which-key
        :init (which-key-mode)
        :diminish which-key-mode
        :config
        (setq which-key-idle-delay 0.3))
      
      (use-package ivy-rich
        :init (ivy-rich-mode 1))
      
      (use-package counsel
        :bind (("M-x" . counsel-M-x)
        ("C-x b" . counsel-ibuffer)
        ("C-x C-b" . counsel-find-file)
        :map minibuffer-local-map
        ("C-r" . counsel-minibuffer-history))
        :config
        (setq ivy-initial-inputs-alist nil)) ;; Make searches not start with ^
      
      (use-package helpful
        :custom
        (counsel-describe-function-function #'helpful-callable)
        (counsel-describe-variable-function #'helpful-variable)
        :bind
        ([remap describe-function] . counsel-describe-function)
        ([remap describe-command] . helpful-command)
        ([remap describe-variable] . counsel-describe-variable)
        ([remap describe-key] . helpful-key))
      
      (use-package general)
      
      (general-define-key
       "C-M-j" 'counsel-switch-buffer
       "C-s" 'counsel-grep-or-swiper)
      
      ;; end of system crafters tutorial
      
      (setq-default indent-tabs-mode nil)
      (setq-default tab-width 4)
      (setq indent-line-function 'insert-tab)
      
      (use-package rustic
        :bind (:map rustic-mode-map
                    ("M-j" . lsp-ui-imenu)
                    ("M-?" . lsp-find-references)
             ("C-c C-c l" . flycheck-list-errors)
                    ("C-c C-c a" . lsp-execute-code-action)
                    ("C-c C-c r" . lsp-rename)
                    ("C-c C-c q" . lsp-workspace-restart)
                    ("C-c C-c Q" . lsp-workspace-shutdown)
                    ("C-c C-c s" . lsp-rust-analyzer-status))
        :config
        ;; uncomment for less flashiness
        ;; (setq lsp-eldoc-hook nil)
        ;; (setq lsp-enable-symbol-highlighting nil)
        ;; (setq lsp-signature-auto-activate nil)
      
        ;; comment to disable rustfmt on save
        (setq rustic-format-on-save t)
        (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))
      
      (defun rk/rustic-mode-hook ()
        ;; so that run C-c C-c C-r works without having to confirm, but don't try to
        ;; save rust buffers that are not file visiting. Once
        ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
        ;; no longer be necessary.
        (when buffer-file-name
          (setq-local buffer-save-without-query t))
        (add-hook 'before-save-hook 'lsp-format-buffer nil t))
      
      (use-package lsp-mode
        :commands lsp
        :custom
        ;; what to use when checking on-save. "check" is default, I prefer clippy
        (lsp-rust-analyzer-cargo-watch-command "clippy")
        (lsp-eldoc-render-all t)
        (lsp-idle-delay 0.6)
        ;; enable / disable the hints as you prefer:
        (lsp-inlay-hint-enable t)
        ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
        (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
        (lsp-rust-analyzer-display-chaining-hints t)
        (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
        (lsp-rust-analyzer-display-closure-return-type-hints t)
        (lsp-rust-analyzer-display-parameter-hints nil)
        (lsp-rust-analyzer-display-reborrow-hints nil)
        :config
        (add-hook 'lsp-mode-hook 'lsp-ui-mode))
      
      (use-package lsp-ui
        :commands lsp-ui-mode
        :custom
        (lsp-ui-peek-always-show t)
        (lsp-ui-sideline-show-hover t)
        (lsp-ui-doc-enable nil))
      
      (use-package company
        :custom
        (company-idle-delay 0.5) ;; how long to wait until popup
        ;; (company-begin-commands nil) ;; uncomment to disable popup
        :bind
        (:map company-active-map
            ("C-n". company-select-next)
            ("C-p". company-select-previous)
            ("M-<". company-select-first)
            ("M->". company-select-last)))
      
      (use-package yasnippet
        :config
        (yas-reload-all)
        (add-hook 'prog-mode-hook 'yas-minor-mode)
        (add-hook 'text-mode-hook 'yas-minor-mode))
      
      (use-package company
        ;; ... see above ...
        (:map company-mode-map
       '("<tab>". tab-indent-or-complete)
       '("TAB". tab-indent-or-complete)))
      
      (defun company-yasnippet-or-completion ()
        (interactive)
        (or (do-yas-expand)
            (company-complete-common)))
      
      (defun check-expansion ()
        (save-excursion
          (if (looking-at "\\_>") t
            (backward-char 1)
            (if (looking-at "\\.") t
              (backward-char 1)
              (if (looking-at "::") t nil)))))
      
      (defun do-yas-expand ()
        (let ((yas/fallback-behavior 'return-nil))
          (yas/expand)))
      
      (defun tab-indent-or-complete ()
        (interactive)
        (if (minibufferp)
            (minibuffer-complete)
          (if (or (not yas/minor-mode)
                  (null (do-yas-expand)))
              (if (check-expansion)
                  (company-complete-common)
                (indent-for-tab-command)))))
      
      (use-package lsp-java
        :config
        (add-hook 'java-mode-hook #'lsp))
      
      (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
        backup-by-copying t    ; Don't delink hardlinks
        version-control t      ; Use version numbers on backups
        delete-old-versions t  ; Automatically delete excess backups
        kept-new-versions 5   ; how many of the newest versions to keep
        kept-old-versions 3    ; and how many of the old
      )
      
      (use-package flycheck)
    '';
  };
}
