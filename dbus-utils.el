;;; dbus-utils.el --- Call Emacs function from outside -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Pierre Glandon
;;
;; Author: Pierre Glandon <http://github/Luceurre/emacs-dbus-utils>
;; Maintainer: Pierre Glandon <pglandon78@gmail.com>
;; Created: January 18, 2021
;; Modified: January 18, 2021
;; Version: 0.0.1
;; Keywords: dbus, streamdeck
;; Homepage: https://github.com/pglandon/dbus-utils
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Run Emacs Lisp from outside via dbus
;;
;;; Code:

(require 'dbus)

(defvar luceurre/dbus-utils-service "org.gnu.Emacs.dbus.utils")
(defvar luceurre/dbus-utils-interface "org.gnu.Emacs.dbus.utils")
(defvar luceurre/dbus-utils-path "/org/gnu/Emacs/dbus/utils")

(defun luceurre/dbus-utils-eval-string (string)
  "Evaluate STRING, return t if sucessful."
  (eval (car (read-from-string (format "(progn %s)" string)))))

(dbus-register-service :session luceurre/dbus-utils-service :allow-replacement :replace-existing)

(defun luceurre/dbus-utils-say-hello ()
  "Return DBUS::String Hello."
  '(:string "Hello"))

(defun luceurre/dbus-utils-run (code)
  "Return DBUS::Boolean t if evaluation of string CODE is sucessful."
  (condition-case nil
      (progn (luceurre/dbus-utils-eval-string code)
             '(:boolean t))
      (error '(:boolean nil)))
  )

(dbus-register-method :session luceurre/dbus-utils-service luceurre/dbus-utils-path luceurre/dbus-utils-interface "SayHello" 'luceurre/dbus-utils-say-hello)
(dbus-register-method :session luceurre/dbus-utils-service luceurre/dbus-utils-path luceurre/dbus-utils-interface "Run" 'luceurre/dbus-utils-run)

(provide 'dbus-utils)
;;; dbus-utils.el ends here
