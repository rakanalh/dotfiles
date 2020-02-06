;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;; EMACS

(load-theme 'doom-tomorrow-night t)

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
(setq lsp-rust-analyzer-server-command '("/home/rakan/.cargo/bin/ra_lsp_server"))

(setq-hook! 'rustic-mode-hook counsel-compile-history '("cargo build"))
(add-hook 'rustic-mode-hook #'cargo-minor-mode)

(add-hook 'rust-mode-hook #'rustic-mode)
(after! rustic
  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo build"
        "b" #'cargo-process-build)

  (map! :localleader
        :map rustic-mode-map
        :prefix "b"
        :desc "cargo build"
        "r" #'cargo-process-run))

(after! cargo
  (set-popup-rule! "Cargo Build" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t)
  (set-popup-rule! "Cargo Run" :ignore nil :actions: nil :side 'bottom :width 0.5 :quit 'current :select t))

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
(set-docsets! 'rustic-mode "Rust")
