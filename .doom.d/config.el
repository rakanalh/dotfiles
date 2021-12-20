;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;; EMACS

(load-theme 'doom-tomorrow-night t)
(setq doom-font (font-spec :family "Hack" :size 10))
(custom-theme-set-faces! 'doom-tomorrow-night
 `(flycheck-posframe-background-face :background ,(doom-darken 'grey 0.4))
 `(flycheck-posframe-error-face   :inherit 'flycheck-posframe-face :foreground red)
 `(hi-lock-faces ))

;; (custom-set-faces! '(window-divider :foreground "#363636"))
(setq auth-sources '("~/.authinfo"))

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

(after! projectile
  (require 'f)
  (defun my-projectile-ignore-project (project-root)
    (or
     (f-descendant-of? project-root (expand-file-name "~/.cargo/git"))
     (f-descendant-of? project-root (expand-file-name "~/.cargo/registry"))
     (f-descendant-of? project-root (expand-file-name "~/.rustup")))
  (setq projectile-ignored-project-function #'my-projectile-ignore-project)))

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

;;; LSP
(after! lsp-mode
  (set-popup-rule! "^\\*lsp-help*" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 2 :slot 0)
  (setq lsp-rust-server 'rust-analyzer
      lsp-rust-analyzer-server-command "/home/rakan/.cargo/bin/rust-analyzer"
      lsp-enable-file-watchers nil
      lsp-completion-enable t
      lsp-enable-imenu t
      lsp-rust-analyzer-cargo-watch-enable nil
      lsp-log-io nil
      lsp-ui-doc-delay 0.7
      lsp-ui-doc-enable nil
      lsp-ui-sideline-code-actions-prefix " "
      lsp-ui-sideline-show-hover nil
      lsp-rust-analyzer-server-display-inlay-hints t
      lsp-headerline-breadcrumb-enable t
      lsp-ui-peek-fontify 'always)
  ;; (setq lsp-rust-rustfmt-bin (expand-file-name "~/.cargo/bin/gitfmt"))
  ;; (setq lsp-rust-analyzer-cargo-watch-command "check")
  ;; (set-lookup-handlers! 'lsp-mode :async t
  ;;   :documentation 'lsp-describe-thing-at-point
  ;;   :definition 'lsp-find-definition
  ;;   :references 'lsp-find-references)

  ;; (set-lookup-handlers! 'lsp-ui-mode :async t
  ;;     :definition 'lsp-find-definitions
  ;;     :references 'lsp-ui-peek-find-references)
  ;;
  )

;;;;; DAP
(after! dap-mode
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

;;;;; RUST
; (setq-hook! 'rustic-mode-hook indent-tabs-mode t)
(setq-hook! 'rustic-mode-hook lsp-rust-rustfmt-path (concat (projectile-project-root) "rustfmt.toml"))
(setq rustic-lsp-server 'rust-analyzer)
(setq rustic-format-on-save t)
(setq rustic-lsp-format nil)
(setq eldoc-idle-delay 0.5)
;;(setq rustic-rustfmt-bin (expand-file-name "~/.cargo/bin/gitfmt"))
(setq-hook! 'rustic-mode-hook counsel-compile-history '("cargo build"))
(setq-hook! 'rustic-mode-hook indent-tabs-mode t)
(add-hook 'rustic-mode-hook #'cargo-minor-mode)
(add-hook 'rust-mode-hook #'rustic-mode)
(after! rustic
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
        "t" (cmd! (cargo-process--start "Check Tests" "check --tests"))))

;; (after! cargo
;;   (set-popup-rule! "Cargo Check" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t :vslot 1 :slot 0)
;;   (set-popup-rule! "Cargo Build" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t)
;;   (set-popup-rule! "Cargo Run" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t))

;;;;; Org-Journal
(setq org-directory "~/Documents/org")
(setq org-journal-dir "~/Documents/org/journal")

;;;;; Org-present
(map! :after org-present
      :map org-present-mode-keymap
      :desc "Org present - next slide"
      :n "n" #'org-present-next)

(map! :after org-present
      :map org-present-mode-keymap
      :desc "Org present - next slide"
      :n "p" #'org-present-prev)

;;;;; Org-Brain
(after! org-brain
  (cl-pushnew '("b" "Brain" plain (function org-brain-goto-end)
                "** %i%?\n:RESOURCES:\n- %a\n:END:\n" :empty-lines 1)
              org-capture-templates
              :key #'car :test #'equal)
  (set-evil-initial-state! 'org-brain-visualize-mode 'normal)
  (let (keys)
    (map-keymap (lambda (event function)
                  (push function keys)
                  (push event keys))
                org-brain-visualize-mode-map)
    (apply #'evil-define-key* 'normal org-brain-visualize-mode-map keys)))

;;;;; Google-Translate
(after! google-translate
  (require 'google-translate-smooth-ui)
  (setq google-translate-default-source-language "de")
  (setq google-translate-default-target-language "en")
  (setq google-translate-translation-directions-alist
      '(("de" . "en") ("en" . "de") ("de" . "ar") ("ar" . "de"))))


(require 'org-habit)
;(require 'org-habit-plus)
(after! org (add-to-list 'org-modules 'org-habit t))
;(after! org (add-to-list 'org-modules 'org-habit-plus))
(after! org (setq org-habit-show-habits t
                  org-treat-insert-todo-heading-as-state-change t
                  org-log-into-drawer t
                  org-agenda-dim-blocked-tasks nil))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(after! mu4e
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "Personal"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "rakan.alhneiti@gmail.com")
                  (user-full-name . "Rakan Al-Hneiti")
                  (mu4e-drafts-folder . "/personal/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/personal/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/personal/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/personal/[Gmail]/Trash")))
         (make-mu4e-context
          :name "Work"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "rakan@parity.io")
                  (user-full-name . "Rakan Al-Hneiti")
                  (mu4e-drafts-folder . "/work/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/work/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/work/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/work/[Gmail]/Trash")))))

  (setq mu4e-maildir-shortcuts
        '(("/Gmail/Inbox"             . ?i)
          ("/Gmail/[Gmail]/Sent Mail" . ?s)
          ("/Gmail/[Gmail]/Trash"     . ?t)
          ("/Gmail/[Gmail]/Drafts"    . ?d)
          ("/Gmail/[Gmail]/All Mail"  . ?a)))

  (mu4e-alert-set-default-style 'libnotify)
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display))

;;;;; Documentation
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values '((rustic-format-on-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
