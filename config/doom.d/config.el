;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;; EMACS

(load-theme 'doom-tomorrow-night t)

(setq doom-font (font-spec :family "Fira Code Retina" :size 12))
(setq gc-cons-threshold 100000000)

(custom-theme-set-faces! 'doom-tomorrow-night
  `(flycheck-posframe-background-face :background ,(doom-darken 'grey 0.4))
  `(flycheck-posframe-error-face   :inherit 'flycheck-posframe-face :foreground red)
  `(hi-lock-faces ))

;; (custom-set-faces! '(window-divider :foreground "#363636"))
(setq auth-sources '("~/.authinfo"))
(setq code-review-auth-login-marker 'forge)

(setq doom-theme 'doom-tomorrow-night
      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      display-line-numbers-type t
      evil-split-window-below t
      evil-vsplit-window-right t
      ivy-xref-use-file-path t)

(show-smartparens-mode)

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

;;; SEARCH
(map! :ne "SPC /" #'+default/search-project)

;; Org mode
(after! org
  (setq org-directory "~/Documents/org"
        org-agenda-files (directory-files-recursively "~/Documents/org/" "\\.org$")
        org-agenda-current-time-string ""
        org-agenda-time-grid '((daily) () "" "")
        org-agenda-prefix-format
        '((agenda . "  %?-2i %t ")
          (todo . " %i %-12:c")
          (tags . " %i %-12:c")
          (search . " %i %-12:c"))
        ;;------ Org agenda configuration ------;;;
        ;; Set span for agenda to be just daily
        org-agenda-span 1
        org-agenda-start-day "+0d"
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-agenda-category-icon-alist
        `(("Development" ,(list (nerd-icons-codicon "nf-cod-code" :height 0.8)) nil nil :ascent center)
          ("Family" ,(list (nerd-icons-codicon "nf-cod-home" :v-adjust 0.005)) nil nil :ascent center)
          ("Knowledge" ,(list (nerd-icons-codicon "nf-cod-database" :height 0.8)) nil nil :ascent center)
          ("Personal" ,(list (nerd-icons-octicon "nf-oct-feed_person" :height 0.9)) nil nil :ascent center)
          ("Work" ,(list (nerd-icons-octicon "nf-oct-codespaces" :height 0.9)) nil nil :ascent center)
          )
        org-super-agenda-groups
        '(;; Each group has an implicit boolean OR operator between its selectors.
          (:name " Overdue "  ; Optionally specify section name
           :scheduled past
           :order 2
           :face 'error)
          (:name "Personal "
           :file-path "roam/daily"
           :order 3)
          (:name "Work "
           :file-path "Work/"
           :order 3)
          (:name " Today "  ; Optionally specify section name
           :time-grid t
           :date today
           :scheduled today
           :order 1
           :face 'warning)
          )
        org-roam-directory "~/Documents/org/roam"
        org-roam-db-location "~/Documents/org/roam/org-roam.db"
        org-modern-label-border nil
        org-roam-db-update-on-save t)
  (custom-theme-set-faces! 'doom-tomorrow-night
    `(flycheck-posframe-background-face :background ,(doom-darken 'grey 0.4))
    `(flycheck-posframe-error-face   :inherit 'flycheck-posframe-face :foreground red)
    `(hi-lock-faces )
    `(org-level-3 :inherit outline-3 :height 1.2)
    `(org-level-2 :inherit outline-2 :height 1.5)
    `(org-level-1 :inherit outline-1 :height 1.75)
    `(org-document-title  :height 2.0 :underline nil))

  ;; Custom styles for dates in agenda
  (custom-set-faces!
    '(org-agenda-date :inherit outline-1 :height 1.15)
    '(org-agenda-date-today :inherit diary :height 1.15)
    '(org-agenda-date-weekend :ineherit outline-2 :height  1.15)
    '(org-agenda-date-weekend-today :inherit outline-4 :height 1.15)
    '(org-super-agenda-header :inherit custom-button :weight bold :height 1.05)
    `(link :foreground unspecified :underline nil :background ,(nth 1 (nth 7 doom-themes--colors)))
    '(org-link :foreground unspecified)
    )
  ;; Org-Roam
  (defun my/date (&optional n)
    (unless n (setq n 1)) ; default is +1
    (format-time-string "%Y-%m-%d" (time-add (* n 86400) (current-time))))
  (setq org-roam-dailies-capture-templates
        '(
          ("t" "todo" entry
           "** TODO %?"
           :target
           (file+head+olp
            "%<%Y-%m-%d>.org"
            "%<%Y-%m-%d>\n\n[[file:%(concat (my/date -1) \".org\")][Yesterday]] | [[file:%(concat (my/date) \".org\")][Tomorrow]]\n\n-----\n\n"
            ("⏱ Today's tasks"))
           :empty-lines 1
           :unnarrowed t
           )
          (
           "n" "note" entry
           "** %?"
           :target
           (file+head+olp
            "%<%Y-%m-%d>.org"
            "%<%Y-%m-%d>\n\n[[elisp:org-roam-dailies-find-yesterday][Yesterday]] | [[elisp:org-roam-dailies-find-tomorrow][Tomorrow]]\n\n-----\n\n"
            ("📝 NOTES"))
           :empty-lines 1
           :unnarrowed t
           )
          )
        )
  ;; Function to be run when org-agenda is opened
  (defun org-agenda-open-hook ()
    "Hook to be run when org-agenda is opened"
    (olivetti-mode)
    (if (= text-scale-mode-amount 0)
        (text-scale-adjust 3)))

  ;; Adds hook to org agenda mode, making follow mode active in org agenda
  (add-hook 'org-agenda-mode-hook #'org-agenda-open-hook)

  (map! :leader
        :prefix "n"
        :desc "Capture for today"
        "t" #'org-roam-dailies-capture-today)
  (map! :leader
        :prefix "n"
        :desc "Todo list"
        "T" #'org-todo-list)

  (global-org-modern-mode)
  (org-super-agenda-mode t)
  )

(after! olivetti
  (setq olivetti-style 'fancy
        olivetti-margin-width 300)
  (setq-default olivetti-body-width 100))

;; Projectile
(after! projectile
  (setq projectile-enable-caching t
        projectile-completion-system 'ivy
        projectile-indexing-method 'alien
        projectile-sort-order 'recently-active
        counsel-projectile-sort-buffers nil
        counsel-projectile-sort-projects nil
        counsel-projectile-sort-files nil
        counsel-projectile-sort-directories nil)

  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or
     (f-descendant-of? project-root (expand-file-name "~/.cargo/git"))
     (f-descendant-of? project-root (expand-file-name "~/.cargo/registry"))
     (f-descendant-of? project-root (expand-file-name "~/.rustup"))))
  (setq projectile-ignored-project-function #'my-projectile-ignore-project))


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

;;; LSP
(after! lsp-mode
  (set-popup-rule! "^\\*lsp-help*" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 2 :slot 0)
  (setq
   lsp-auto-guess-root nil
   lsp-enable-file-watchers nil
   lsp-completion-enable t
   ;; lsp-rust-analyzer-diagnostics-enable t
   ;; lsp-rust-analyzer-cargo-watch-command "clippy"
   ;; lsp-rust-analyzer-cargo-override-command ["cargo", "clippy", "--message=format=json"]
   ;; lsp-rust-analyzer-cargo-extra-env ["SKIP_GUEST_BUILD=1"]
   ;; lsp-diagnostic-clean-after-change t
   lsp-enable-imenu t
   lsp-headerline-breadcrumb-enable t
   lsp-log-io nil
   lsp-inlay-hint-enable t
   lsp-ui-doc-enable nil
   lsp-ui-doc-delay 0.7
   lsp-ui-peek-enable nil
   lsp-ui-peek-fontify 'always
   lsp-ui-sideline-show-hover t
   lsp-ui-sideline-show-code-actions t
   lsp-ui-sideline-show-diagnostics t
   lsp-ui-sideline-code-actions-prefix " "
   lsp-rust-server 'rust-analyzer
   lsp-rust-analyzer-cargo-run-build-scripts nil
   lsp-rust-analyzer-cargo-watch-enable nil
   lsp-rust-analyzer-display-chaining-hints t
   lsp-rust-analyzer-closure-return-type-hints t
   lsp-rust-analyzer-display-closure-return-type-hints t
   lsp-rust-analyzer-display-parameter-hints t
   lsp-rust-analyzer-expression-adjustment-hints "never"
   lsp-rust-analyzer-checkonsave-features "all"
   lsp-rust-clippy-preference "on"
   lsp-rust-proc-macro-enable t
   )
  ;; (setq lsp-rust-rustfmt-bin (expand-file-name "~/.cargo/bin/gitfmt"))
  ;; (setq lsp-rust-analyzer-cargo-watch-command "check")
  (set-lookup-handlers! 'rustic-mode
    :definition #'+lsp-lookup-definition-handler
    :references #'+lsp-lookup-references-handler
    :documentation '(lsp-describe-thing-at-point :async t)
    :implementations '(lsp-find-implementation :async t)
    :type-definition #'lsp-find-type-definition)

  ;; (set-lookup-handlers! 'lsp-mode
  ;;   :definition #'+lsp-lookup-definition-handler
  ;;   :references #'+lsp-lookup-references-handler
  ;;   :documentation '(lsp-describe-thing-at-point :async t)
  ;;   :implementations '(lsp-find-implementation :async t)
  ;;   :type-definition #'lsp-find-type-definition)

  ;; (set-lookup-handlers! 'lsp-ui-mode :async t
  ;;   :definition 'lsp-find-definitions
  ;;   :references 'lsp-ui-peek-find-references)
  (set-popup-rule! "^\\*lsp-help*" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 2 :slot 0))

;;;;; DAP
(after! dap-mode
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

;;;;; PYTHON
(after! python-mode
  (add-hook 'before-save-hook #'py-isort-before-save)
  (setq-hook! 'python-mode-hook flycheck-checker 'python-mypy))

;;;;; RUST
(after! rustic
  (setq rustic-lsp-server 'rust-analyzer
        rustic-format-on-save t
        rustic-lsp-format nil
        eldoc-idle-delay 0.5
        flycheck-rust-check-tests nil
        ;; Override rustic's cargo output font colors
        rustic-ansi-faces ["black"
                           "OrangeRed3"
                           "green3"
                           "yellow3"
                           "SlateGray1"
                           "magenta3"
                           "cyan3"
                           "white"])

  ;; rustic-analyzer-command '("~/.config/emacs/bin/rust-analyzer.sh"))

  (add-hook 'rustic-mode-hook #'cargo-minor-mode)

  ;;   (map! :localleader
  ;;         :map rustic-mode-map
  ;;         :prefix "b"
  ;;         :desc "cargo build"
  ;;         "c" #'cargo-process-check)

  ;;   (map! :localleader
  ;;         :map rustic-mode-map
  ;;         :prefix "b"
  ;;         :desc "cargo build"
  ;;         "b" #'cargo-process-build)

  ;;   (map! :localleader
  ;;         :map rustic-mode-map
  ;;         :prefix "b"
  ;;         :desc "cargo build"
  ;;         "r" #'cargo-process-run)
  (map! :localleader
        :map rustic-mode-map
        :prefix "r"
        :desc "cargo check runtime-benchmarks"
        "t" (cmd! (cargo-process--start "Check Tests" "check --features \"runtime-benchmarks\"")))
  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo check w/ tests"
        "t" (cmd! (cargo-process--start "Check Tests" "check --tests")))
  (map! :localleader
        :map rustic-compilation-mode-map
        :prefix "["
        :desc "Next Error"
        "[" #'compilation-next-error)
  (map! :localleader
        :map rustic-compilation-mode-map
        :prefix "]"
        :desc "Previous Error"
        "]" #'compilation-previous-error)

  ;; (after! cargo
  ;;   (set-popup-rule! "Cargo Check" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 1 :slot 0)
  ;;   (set-popup-rule! "Cargo Build" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t)
  ;;   (set-popup-rule! "Cargo Run" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t))
  )

;;; Overrides
(eval-after-load "ivy-xref"
  '(defun ivy-xref-make-collection (xrefs)
     "Transform XREFS into a collection for display via `ivy-read'."
     (let ((collection nil))
       (dolist (xref xrefs)
         (let* ((summary (xref-item-summary xref))
                (location  (xref-item-location xref))
                (line (xref-location-line location))
                (file (xref-location-group location))
                (candidate
                 (concat
                  (propertize
                   (concat
                    (if ivy-xref-use-file-path
		        (let (project-root (projectile-project-root))
                          (file-relative-name file project-root))
                      (file-name-nondirectory file))
                    (if (integerp line)
                        (format ":%d: " line)
                      ": "))
                   'face 'compilation-info)
                  (progn
                    (when ivy-xref-remove-text-properties
                      (set-text-properties 0 (length summary) nil summary))
                    summary))))
           (push `(,candidate . ,location) collection)))
       (nreverse collection))))
