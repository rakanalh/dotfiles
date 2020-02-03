;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
;;
(package! auto-highlight-symbol)

(package! rust-mode :disable t)

(package! whitespace-mode :disable t)

(package! cargo)

(package! flycheck-mypy)

(package! buku :recipe (:host github :repo "flexibeast/ebuku"))

(package! parent-mode)
