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

(package! org-journal)

(package! org-present)

(package! protobuf-mode)

(package! google-translate)

(unpin! rustic lsp-mode lsp-ui)
