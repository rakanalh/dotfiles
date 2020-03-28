;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;; EMACS

(load-theme 'doom-tomorrow-night t)
(setq doom-font (font-spec :family "Menlo" :size 10))
(custom-theme-set-faces! 'doom-tomorrow-night
 `(flycheck-posframe-background-face :background ,(doom-darken 'grey 0.4))
 `(flycheck-posframe-error-face   :inherit 'flycheck-posframe-face :foreground red)
 `(hi-lock-faces ))

;; (custom-set-faces! '(window-divider :foreground "#363636"))


(setq doom-theme 'doom-tomorrow-night
      projectile-enable-caching t
      projectile-completion-system 'ivy
      projectile-indexing-method 'native
      projectile-sort-order 'recently-active
      counsel-projectile-sort-buffers t
      counsel-projectile-sort-projects t
      counsel-projectile-sort-files t
      counsel-projectile-sort-directories t
      flycheck-rust-check-tests nil
      ebuku-buku-path "/usr/bin/buku")

;; Override rustic's cargo output font colors
(setq rustic-ansi-faces ["black"
                         "OrangeRed3"
                         "green3"
                         "yellow3"
                         "SlateGray1"
                         "magenta3"
                         "cyan3"
                         "white"])
;;; WINDOWS
(map! :leader
      :prefix "w"
      "0" #'delete-window)

(map! :leader
      :prefix "w"
      "1" #'delete-other-windows)

(map! :leader
      :prefix "w"
      "SPC" #'other-window)

(setq evil-split-window-below t)
(setq evil-vsplit-window-right t)
;; (defun split-window-below-and-switch ()
;;   "Split the window horizontally, then switch to the new pane."
;;   (interactive)
;;   (split-window-below)
;;   (other-window 1))

;; (defun split-window-right-and-switch ()
;;   "Split the window vertically, then switch to the new pane."
;;   (interactive)
;;   (split-window-right)
;;   (other-window 1))

;; (map! :leader
;;       :prefix "w"
;;       "v" #'split-window-right-and-switch)

;; (map! :leader
;;       :prefix "w"
;;       "s" #'split-window-below-and-switch)

;;; SEARCH
(map! :ne "SPC /" #'+default/search-project)


;;; WHITESPACE MODE
(after! whitespace
  (whitespace-global-modes -1))

;;; Terminal
(add-hook! 'vterm-mode-hook
    (add-hook 'doom-switch-window-hook #'evil-insert-state nil 'local))

;;; FLYCHECK
(map! :nv "[e" #'flycheck-previous-error)
(map! :nv "]e" #'flycheck-next-error)

;;; MAGIT
(map! :leader
      :prefix "g"
      :desc "Magit resolve"
      "e" #'magit-ediff-resolve)

;;; EVIL-MC
(map! :nv "gzs"
      #'evil-mc-skip-and-goto-next-match)
(map! :nv
      "gzS" #'evil-mc-skip-and-goto-prev-match)
(map! :v "C-n" (general-predicate-dispatch nil ; fall back to nearest keymap
                 (featurep! :editor multiple-cursors)
                 #'evil-mc-make-and-goto-next-match))
(map! :n "C-n" (general-predicate-dispatch nil ; fall back to nearest keymap
                 (and (featurep! :editor multiple-cursors)
                      (bound-and-true-p evil-mc-cursor-list))
                 #'evil-mc-make-and-goto-next-match))
(map! :n "C-S-n" #'evil-mc-make-cursor-move-next-line)

;;;;; PYTHON
(add-hook 'before-save-hook #'py-isort-before-save)
(setq-hook! 'python-mode-hook flycheck-checker 'python-mypy)

;;;;; RUST
(setq-hook! 'rustic-mode-hook indent-tabs-mode t)
(setq lsp-rust-server 'rust-analyzer)
(setq lsp-rust-analyzer-server-command "/Users/rakan/.cargo/bin/rust-analyzer")
(setq lsp-enable-file-watchers nil)
(setq lsp-enable-completion-at-point t)
(setq lsp-enable-imenu t)
(setq lsp-rust-analyzer-cargo-watch-enable nil)
(setq lsp-log-io t)
(setq lsp-ui-doc-delay 0.7)
(setq eldoc-idle-delay 0.5)
;; (setq lsp-rust-rustfmt-bin (expand-file-name "~/.cargo/bin/gitfmt"))
;; (setq lsp-rust-analyzer-cargo-watch-command "check")
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-format-on-save nil)
(setq rustic-lsp-format nil)
;;(setq rustic-rustfmt-bin (expand-file-name "~/.cargo/bin/gitfmt"))

(setq-hook! 'rustic-mode-hook counsel-compile-history '("cargo build"))
(add-hook 'rustic-mode-hook #'cargo-minor-mode)
(add-hook 'rust-mode-hook #'rustic-mode)

(after! rustic
  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo build"
        "c" #'cargo-process-check)

  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo build"
        "b" #'cargo-process-build)

  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo build"
        "r" #'cargo-process-run)
  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo check w/ tests"
        "t" (lambda! (cargo-process--start "Check Tests" "check --tests"))))

(after! cargo
  (set-popup-rule! "Cargo Check" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 1 :slot 0)
  (set-popup-rule! "Cargo Build" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t)
  (set-popup-rule! "Cargo Run" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t))

(setq lsp-ui-peek-fontify 'always)

;;; LSP
(set-popup-rule! "^\\*lsp-help*" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 2 :slot 0)
;; (set-lookup-handlers! 'lsp-mode :async t
;;   :documentation 'lsp-describe-thing-at-point
;;   :definition 'lsp-find-definition
;;   :references 'lsp-find-references)

;; (set-lookup-handlers! 'lsp-ui-mode :async t
;;     :definition 'lsp-find-definitions
;;     :references 'lsp-ui-peek-find-references)

;;;;; EBUKU
(map! :mode ebuku-mode
      :map ebuku-mode-map
      :n
      "j" #'next-line
      "k" #'previous-line
      "h" #'backward-char
      "l" #'forward-char
      "a" #'ebuku-add-bookmark
      "e" #'ebuku-edit-bookmark
      "d" #'ebuku-delete-bookmark
      "s" #'ebuku-search
      "r" #'ebuku-refresh)

;;;;; Documentation
