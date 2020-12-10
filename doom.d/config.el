;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "h5vx"
      user-mail-address "h5v@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 17 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Varela Round" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))  ; or lsp-deferred

(use-package ccls)

(after! org
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
)

(with-eval-after-load 'treemacs
  (defun treemacs-ignore-gitignore (file _)
    (string= file ".gitignore"))
  (push #'treemacs-ignore-gitignore treemacs-ignored-file-predicates))


(add-hook 'hack-local-variables-hook
          (lambda ()
            (when (derived-mode-p 'python-mode)
              (require 'lsp-python-ms)
              (lsp)))) ; or lsp-deferred


(map! :n "J" 'centaur-tabs-forward
      :n "K" 'centaur-tabs-backward
      :n "Q" 'kill-current-buffer
      :n "ZC" 'doom/kill-other-buffers
      :n "H" 'evil-jump-backward
      :n "C-}" 'lsp-extend-selection
      :n "C-J" 'join-line
      :leader :desc "Push" :n "gk" 'magit-push-to-remote
      :leader :desc "Pull" :n "gp" 'magit-pull-from-upstream
      )
