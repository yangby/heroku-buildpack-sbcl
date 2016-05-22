; -*- coding: utf-8; mode: Lisp; fill-column: 76; tab-width: 4; -*-
; Brief: Compile sources.
;       bin/compile.lisp BUILD_DIR CACHE_DIR ENV_DIR

(in-package :cl-user)

(defun log-base (prefix fmt &rest args)
  (let ((newfmt (concatenate 'string prefix fmt "~%")))
    (apply #'format t newfmt args)))

(defun log-title (fmt &rest args)
  (apply #'log-base "       -----> " fmt args))
(defun log-content (fmt &rest args)
  (apply #'log-base "              " fmt args))
(defun log-footer (fmt &rest args)
  (apply #'log-base "              [DONE]" fmt args))

(log-title "Checking input parameters ...")

(unless (>= (length sb-ext:*posix-argv*) 5)
  (log-content
   "[ERROR] Required arguments: BUILD_DIR CACHE_DIR ENV_DIR VIRTUAL_ROOT")
  (sb-ext:exit :code 1))

(defvar *build-dir*    (pathname (nth 1 sb-ext:*posix-argv*)))
(defvar *cache-dir*    (pathname (nth 2 sb-ext:*posix-argv*)))
(defvar   *env-dir*    (pathname (nth 3 sb-ext:*posix-argv*)))
(defvar *virtual-root* (pathname (nth 4 sb-ext:*posix-argv*)))
(defvar *build-file* (merge-pathnames "build.lisp" *build-dir*))

(log-content "      BUILD_DIR = ~a" *build-dir*)
(log-content "      CACHE_DIR = ~a" *cache-dir*)
(log-content "        ENV_DIR = ~a"   *env-dir*)
(log-content "   VIRTUAL_ROOT = ~a" *virtual-root*)
(log-content "     Build File = ~a" *build-file*)
(log-footer "")

(defmacro fncall (funname &rest args)
  `(funcall (read-from-string ,funname) ,@args))

(log-title "Loading Quicklisp and Updating packages ...")
(require :asdf)
(asdf:disable-output-translations)

(defun require-quicklisp ()
  (let ((ql-init (merge-pathnames "quicklisp/setup.lisp" *virtual-root*))
        (ql-install (merge-pathnames "quicklisp.lisp" *virtual-root*)))
    (if (probe-file ql-init)
        (load ql-init)
        (progn
          (load ql-install)
          (log-content "Installing the Quicklisp client ...")
          (fncall "quicklisp-quickstart:install"
                  :path (make-pathname
                         :directory (pathname-directory ql-init)))))))

(require-quicklisp)
(log-content "Updating the Quicklisp client ...")
(ql:update-client)
(log-content "Updating packages from Quicklisp ...")
(ql:update-all-dists)
(log-footer "")

(log-title "SBCL-Framework has been installed successfully.")
(log-content "        SBCL Version ~a."(lisp-implementation-version))
(log-content "        ASDF Version ~a." (asdf:asdf-version))
(log-content "   Quicklisp Version ~a." (quicklisp-client:client-version))
(log-footer "")

(if (probe-file *build-file*)
    (load *build-file*)
    (progn
      (log-content
       "[ERROR] Build File [~a] is not existed." *build-file*)
      (sb-ext:exit :code 1)))

(exit)
