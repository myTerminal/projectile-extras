;;; projectile-extras.el --- A few extra functions for projectile -*- lexical-binding: t; coding: utf-8; -*-

;; This file is not part of Emacs

;; Author: Mohammed Ismail Ansari <team.terminal@gmail.com>
;; Keywords: project, convenience
;; Package-Version: 20170928.2035
;; Maintainer: Mohammed Ismail Ansari <team.terminal@gmail.com>
;; Created: 2017/09/28
;; Package-Requires: ((emacs "24") (cl-lib "0.5"))
;; Description: A few extra functions for projectile
;; URL: http://ismail.teamfluxion.com
;; Compatibility: Emacs24


;; COPYRIGHT NOTICE
;;
;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2 of the License, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
;; for more details.
;;

;;; Install:

;; Put this file on your Emacs-Lisp load path and add the following to your
;; ~/.emacs startup file
;;
;;     (require 'projectile-extras)
;;
;; Currently *projectile-extras* provides the following functions:
;;
;;  - projectile-find-all-occurrences
;;  - projectile-find-all-references
;;

;;; Commentary:

;;     You can use *projectile-extras* as a supplement to projectile for a
;;     few extra functions
;;
;;  Overview of features:
;;
;;     o   projectile-find-all-occurrences
;;     o   projectile-find-all-references
;;

;;; Code:

(require 'cl-lib)

(require 'projectile)

;;;###autoload
(defun projectile-find-all-occurrences (&optional arg)
  "List all occurrences of the text being searched using completion.
With a prefix argument ARG prompts you for a directory on which to run search in."
  (interactive "P")
  (let* ((text-to-search (read-string
                          (projectile-prepend-project-name "Find all: ")
                          (projectile-symbol-or-selection-at-point)))
         (directory (if arg
                        (file-name-as-directory
                         (read-directory-name "Find in directory: "))
                      (projectile-project-root)))
         (file-to-search (projectile-files-with-string text-to-search directory)))
    (projectile-completing-read
     "All occurrences: "
     (reduce #'append
             (mapcar (lambda (file)
                       (with-temp-buffer
                         (insert-file-contents file)
                         (let ((lines (split-string (buffer-string) "\n")))
                           (cl-remove-if nil
                                         (mapcar (lambda (line)
                                                   (let ((present-in-linep (search text-to-search line)))
                                                     (cond (present-in-linep (concat (cadr (split-string file (projectile-project-root)))
                                                                                     " => line "
                                                                                     (number-to-string (1+ (cl-position line lines)))))
                                                           (t nil))))
                                                 lines)))))
                     file-to-search))
     :action `(lambda (item)
                (let ((file (car (split-string item " => line ")))
                      (line-number (string-to-number (cadr (split-string item " => line ")))))
                  (find-file (expand-file-name file (projectile-project-root)))
                  (beginning-of-buffer)
                  (forward-line (1- line-number))
                  (search-forward ,text-to-search)
                  (set-mark-command nil)
                  (search-backward ,text-to-search)
                  (run-hooks 'projectile-find-file-hook))))))

;;;###autoload
(defun projectile-find-all-references (&optional arg)
  "List all references of the symbol under cursor using completion.
With a prefix argument ARG prompts you for a directory on which to run search in."
  (interactive "P")
  (let* ((text-to-search (cond ((use-region-p) (buffer-substring-no-properties (region-beginning) (region-end)))
                               (t (thing-at-point 'symbol))))
         (directory (if arg
                        (file-name-as-directory
                         (read-directory-name "Find in directory: "))
                      (projectile-project-root)))
         (file-to-search (projectile-files-with-string text-to-search directory)))
    (projectile-completing-read
     "All references: "
     (reduce #'append
             (mapcar (lambda (file)
                       (with-temp-buffer
                         (insert-file-contents file)
                         (let ((lines (split-string (buffer-string) "\n")))
                           (cl-remove-if nil
                                         (mapcar (lambda (line)
                                                   (let ((present-in-linep (search text-to-search line)))
                                                     (cond (present-in-linep (concat (cadr (split-string file (projectile-project-root)))
                                                                                     " => line "
                                                                                     (number-to-string (1+ (cl-position line lines)))))
                                                           (t nil))))
                                                 lines)))))
                     file-to-search))
     :action `(lambda (item)
                (let ((file (car (split-string item " => line ")))
                      (line-number (string-to-number (cadr (split-string item " => line ")))))
                  (find-file (expand-file-name file (projectile-project-root)))
                  (beginning-of-buffer)
                  (forward-line (1- line-number))
                  (search-forward ,text-to-search)
                  (set-mark-command nil)
                  (search-backward ,text-to-search)
                  (run-hooks 'projectile-find-file-hook))))))

(provide 'projectile-extras)

;;; projectile-extras.el ends here
