;;; packages.el --- miyon_org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <Miyon@MIYON-PC>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `miyon_org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `miyon_org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `miyon_org/pre-init-PACKAGE' and/or
;;   `miyon_org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst miyon_org-packages
  '(
    (org :location built-in)
    )
  "The list of Lisp packages required by the miyon_org layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun miyon_org/post-init-org ()
  "docstring"
  (add-hook 'org-mode-hook (lambda () (spacemacs/toggle-line-numbers-off)) 'append)
  (with-eval-after-load 'org
    (progn
      (spacemacs|disable-company org-mode)

      (setq org-refile-use-outline-path 'file)
      (setq org-outline-path-complete-in-steps nil)
      (setq org-refile-targets
            '((nil :maxlevel . 3)
              (org-agenda-files :maxlevel . 3)))
      (setq org-refile-allow-creating-parent-nodes 'confirm)

      (setq org-plantuml-jar-path
            (expand-file-name "~/.emacs.d/private/plantuml.jar"))
      (setq org-ditaa-jar-path
            (expand-file-name "~/.emacs.d/private/ditaa.jar"))

      (defconst org-agenda-dir "/home/miyon/Documents/GTD/")
      (setq org-agenda-file-project (expand-file-name "project.org" org-agenda-dir))
      (setq org-agenda-file-finished (expand-file-name "finished.org" org-agenda-dir))
      (setq org-agenda-file-personal (expand-file-name "personal.org" org-agenda-dir))
      (setq org-default-notes-file (expand-file-name "inbox.org" org-agenda-dir))
      (setq org-agenda-files (list org-agenda-dir))
      (setq org-todo-keywords
            '((sequence "TODO(t!)" "|" "DONE(d@/!)" "ABORT(a@/!)")
              ))
      ;; the %i would copy the selected text into the template
      ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
      (setq org-capture-templates
            '(("i" "Inbox" entry (file+headline org-agenda-file-note "Inbox")
               "* %? :inbox:\n %i\n %U"
               :empty-lines 1)
              ("r" "Remind" entry (file+headline org-agenda-file-personal "Remind")
               "* TODO [#B] %? :remind:\n %i\n"
               :empty-lines 1)
              ("s" "Skill" entry (file+headline org-agenda-file-personal "Skill")
               "* TODO [#B] %? :skill:\n %i\n"
               :empty-lines 1)
              ("b" "New Books" entry (file+headline org-agenda-file-personal "Books")
               "* TODO [#C] %? :book:\n %i\n"
               :empty-lines 1)
              ("p" "New Project" entry (file org-agenda-file-project)
               "* [#A] %?\n %i\n"
               :empty-lines 1)
            ))

      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "ib" 'miyon/org-insert-src-block
        )
      ))
  )
;;; packages.el ends here
