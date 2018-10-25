;;; init.el --- Emacs configuration

;; Author: Andrew Pensinger

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Many thanks to Emacs Redux and What the .emacs.d!?

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;;;; Package Repositories

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

;;;; Set Visuals

(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(load-theme 'leuven t)
(column-number-mode t)

;;;; Setup Use-Package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'diminish)
  (package-refresh-contents)
  (package-install 'diminish))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;;;; Disable Annoyances

(setq-default buffer-file-coding-system 'utf-8-unix)
(setq ring-bell-function 'ignore)
(defalias 'yes-or-no-p 'y-or-n-p)  ;; Enable y/n answers

;;;; Backups

;; Write backuop files to their own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
		 (concat user-emacs-directory "backups"))))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 5
      kept-old-versions 5)

;; Make backups of files, even when they're in version control
(setq vs-make-backup-files t)

;;;; Misc. Keybindings

(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)

;;;; ido

(use-package ido
  :ensure ido-vertical-mode
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))

;;;; Other Packages

(use-package crux
  :ensure t
  :bind (([remap move-beginning-of-line] . crux-move-beginning-of-line)
	 ("C-k" . crux-smart-kill-line)
	 ("C-S-o" . crux-smart-open-line-above)
	 ("C-o" . crux-smart-open-line)
	 ("C-j" . crux-top-join-line)))

(use-package god-mode
  :ensure t
  :diminish (god-local-mode . " g")
  :bind (("<escape>" . god-mode-all)
	 :map god-local-mode-map
	 ("i" . god-local-mode)))

(use-package hydra
  :ensure t)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package avy
  :ensure t
  :bind ("C-;" . hydra-avy/body)
  :config
  (defhydra hydra-avy (:hint nil :exit t)
    "
_c_har _l_ine _w_ord"
    ("c" avy-goto-char)
    ("l" avy-goto-line)
    ("w" avy-goto-word-1)))

(use-package ace-window
  :ensure t
  :bind ("C-:" . ace-window))

(use-package editorconfig
  :ensure t
  :diminish editorconfig-mode
  :config
  (editorconfig-mode 1))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (setq yas-snippet-dirs
	'("~/.emacs.d/snippets"
	  "~/.emacs.d/yasnippet-snippets/snippets"
	  ))
  (yas-global-mode 1))

(use-package markdown-mode
  :ensure t)

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :interpreter "node"
  :config
  (use-package json-mode :ensure t))

;;;; Custom

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
