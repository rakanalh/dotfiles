;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
;;
(package! auto-highlight-symbol)

(package! rust-mode :disable t)

(package! format-all :disable t)

(package! whitespace :disable t)

(package! cargo)

(package! flycheck-mypy)

(package! parent-mode)

(package! rust-playground)

(package! org-present)

(package! mu4e-dashboard
  :recipe (:host github :repo "rougier/mu4e-dashboard"))

;; (package! org-habit-plus
;;   :recipe (:host github :repo "oddious/org-habit-plus"))

(package! protobuf-mode)

(package! google-translate)

(package! org-gtasks
  :recipe
  (:host github
   :repo "rakanalh/org-gtasks"
   :files ("org-gtasks.el")))

;; (package!
;;  github-review
;;  :recipe
;;     (:host github
;;      :repo "charignon/github-review"
;;      :files ("github-review.el")))

(unpin! rustic lsp-mode lsp-ui)
