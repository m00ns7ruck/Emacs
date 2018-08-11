;;; cAndCpp_conf --- Holds the configurations for C / C++

;;; Commentary:
;; - C/C++ configurations and packages to make work
;; with these languages easier and more pleasant (not
;; that it could be any more than it already is :-) )



;;; Code:
;;==========================
;;= C / C++ Configurations =
;;==========================
;; - Set styles for C/C++ and hook them
;; - Lsp-clangd
;; - Cquery




;;========================
;;= Set C and C++ Styles =
;;=     and Hook them    =
;;========================



;; - Set C style
(setq-default c-indent-tabs-mode nil
	      c-indent-level 4
	      c-argdecl-indent 0
	      backward-delete-function nil)

;; - Indent or complete with <TAB>
(setq tab-always-indent 'complete)

(defun my-c-lineup-arglist-lambda (langelem)
  "Line up lambda."
  (save-excursion
    (back-to-indentation)
    (when (looking-at "{")
      '+)))

(c-add-style "Iv O'Style"
	     '("linux"
	       (indent-tabs-mode nil)
	       (c-basic-offset . 4)
	       (c-offsets-alist . ((inline-open . +)
				   (brace-list-open . +)
				   (statement-case-open . +)
				   (substatement-open . 0)
				   (block-open . +)
				   (case-label . +)
				   (arglist-cont-nonempty
				    (my-c-lineup-arglist-lambda c-lineup-arglist))))))

(defun my-c-mode-hook()
  (c-set-style "Iv O'Style")
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 0)
  (subword-mode 1)
  ;; (c-toggle-syntactic-indentation 1)
  (c-hungry-delete 1))


;; - Set C++ style
(defun my-c++-mode-hook ()
  (c-set-style "Iv O'Style")
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 0)
  (subword-mode 1)
  ;; (c-toggle-syntactic-indentation 1)
  )



;; - Hook the styles
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;========================



;;==============
;;= Lsp-clangd =
;;==============
(use-package lsp-clangd
  :ensure t
  :init
  (add-hook 'c++-mode-hook #'lsp-clangd-c++-enable))
;;==============



;;==========
;;= Cquery =
;;==========
(use-package cquery
  :ensure t
  :init
  (add-hook 'c-mode-hook #'cquery//enable)
  (add-hook 'c++-mode-hook #'cquery//enable)
  :config
  (setq cquery-executable "/usr/bin/cquery") ;; Path to cquery executable
  (setq cquery-extra-init-params '(:index (:comments 2) :cacheFormat "msgpack"))

  (with-eval-after-load 'projectile
  (setq projectile-project-root-files-top-down-recurring
        (append '("compile_commands.json"
                  ".cquery")
                projectile-project-root-files-top-down-recurring)))

  (setq cquery-extra-init-params '(:index (:comments 2) :cacheFormat "msgpack" :completion (:detailedLabel t)))

  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)

  ;; (setq cquery-sem-highlight-method 'font-lock)

  ;; For rainbow semantic highlighting
  (cquery-use-default-rainbow-sem-highlight)

  (defun cquery//enable ()
    (condition-case nil
	(lsp-cquery-enable)
      (user-error nil)))

  (lsp-cquery-enable))
;;==========



(provide 'cAndCpp_conf)
;;; cAndCpp_conf.el ends here
