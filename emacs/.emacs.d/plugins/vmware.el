;;;
;;;
;;; Basic typing aids for file and function header etc.
;;; following the VMware conventions.

; VMware coding standard style for Emacs cc-mode, based on data
; from the VMware Engineering Manual:
; http://vmweb.vmware.com/~mts/WebSite/guide/programming/engman.html

; Also see the related Host Agent/VMA Core coding standards:
; https://wiki.eng.vmware.com/CodingStandardWiki

(defun c-lineup-ObjC-method-call-colons (langelem)
  "Line up the colons of selector args with the first selector.

If no decision can be made return NIL, so that other lineup methods can be
tried.  This is typically chained with `c-lineup-ObjC-method-call'."

  (save-excursion
    (catch 'no-idea
      (let* ((method-arg-len (progn
                               (back-to-indentation)
                               (if (search-forward ":" (c-point 'eol) 'move)
                                   (- (point) (c-point 'boi))
                                        ; no complete argument to indent yet
                                 (throw 'no-idea nil))))
             (extra (save-excursion
                                        ; indent parameter to argument if needed
                      (back-to-indentation)
                      (c-backward-syntactic-ws (cdr langelem))
                      (if (eq ?: (char-before))
                          (c-get-offset '(objc-method-parameter-offset . nil))
                        0)))
             (open-bracket-col (c-langelem-col langelem))
             (arg-ralign-colon-ofs (progn
                                     (forward-char) ; skip over '['
                                        ; skip over object/class name
                                        ; and first argument
                                     (c-forward-sexp 2)
                                     (if (search-forward ":" (c-point 'eol) 'move)
                                         (- (current-column) open-bracket-col
                                            method-arg-len extra)
                                        ; previous arg has no param
                                       (c-get-offset '(objc-method-arg-unfinished-offset . nil))))))
        (if (>= arg-ralign-colon-ofs
                (c-get-offset '(objc-method-arg-min-delta-to-bracket . nil)))
            (+ arg-ralign-colon-ofs extra)
          (throw 'no-idea nil)
          )))))


(c-add-style "vmware-c-c++-engineering-manual"
             '((c-basic-offset . 3)     ; 3 space indent
               (indent-tabs-mode . nil) ; use spaces instead of tabs
               (comment-start . "/*")   ; use C-style comments even in C++-mode
               (comment-end . "*/")
               (comment-style . extra-line)
               (c-comment-only-line-offset . 0)
               (c-hanging-braces-alist . ((substatement-open before after)))
               (c-offsets-alist . ((topmost-intro        . 0)
                                   (topmost-intro-cont   . 0)
                                   (substatement         . +)
                                   (substatement-open    . 0)
                                   (statement-case-open  . +)
                                   (statement-cont       . +)
                                   (access-label         . -)
                                   (inclass              . +)
                                   (inline-open          . 0)
                                   (innamespace          . 0)
                                   (objc-method-args-cont . c-lineup-ObjC-method-args)
                                   (objc-method-call-cont . (c-lineup-ObjC-method-call-colons
                                                             c-lineup-ObjC-method-call
                                                             +))
                                   (label                . 0)
                                   ))))

(defun vmware-c-mode-setup ()
  (c-set-style "vmware-c-c++-engineering-manual"))

; These are what actually make our style take effect in C, C++, and Obj-C modes
(add-hook 'c-mode-hook 'vmware-c-mode-setup)
(add-hook 'c++-mode-hook 'vmware-c-mode-setup)
(add-hook 'objc-mode-hook 'vmware-c-mode-setup)

(defun vmware-insert-file-header ()
  (interactive)
  (let ((name (car (split-string (buffer-name nil) "\\."))))
     (insert-string (concat "\
/* **********************************************************
 * Copyright " (int-to-string (nth 5 (decode-time)))
                  " VMware, Inc.  All rights reserved.
 * -- VMware Confidential
 * **********************************************************/

/*
 * " (buffer-name nil) " --
 *
 *      XXX: Brief description of this file.
 */
"))))


(defun vmware-insert-objc-function-header (class name)
  (interactive "sClass name: \nsFunction name: ")
  (insert-string (concat "\
/*
 *-----------------------------------------------------------------------------
 *
 * -[" class " " name "] --
 *
 *      XXX
 *
 * Results:
 *      XXX
 *
 * Side effects:
 *      XXX
 *
 *-----------------------------------------------------------------------------
 */

- (void)" name (if (string-match ":$" name) " " "") "
{
}


" ))
  (if (string-match ":$" name)
      (re-search-backward "\n{")
    (re-search-backward "\n}")))


(defun vmware-insert-function-header (name)
  (interactive "sFunction name: ")
  (insert-string (concat "\
/*
 *-----------------------------------------------------------------------------
 *
 * " name " --
 *
 *      XXX
 *
 * Results:
 *      XXX
 *
 * Side effects:
 *      XXX
 *
 *-----------------------------------------------------------------------------
 */

void
" name "()
{
}


" )))


;;; XXX broken.  Don't use.

(defun vmware-commentify-arglist (prefix)
  (interactive "P")
  (let ((x (point)))
	(backward-up-list 1)
	(beginning-of-line)
	(let ((begin (point)))
	  (forward-list)
	  (end-of-line)
	  (let ((end (point)))
	    (narrow-to-region begin end)
	    (goto-char begin)
	    (if prefix

		;; Remove comments.
		(let ((done nil)
		      too-long)
		  (while (re-search-forward "[ \t]*//.*$" nil t)
		    (replace-match "" nil nil))
		  (goto-char begin)
		  (while (not done)
		    (re-search-forward "[,)]")
		    (if (equal ")" (match-string 0))
			(setq done t)
		      (join-lines)
		      (let ((x (point)))
		         (end-of-line)
			 (setq too-long (> (current-column) 78))
			 (goto-char x))
		      (if too-long
			  (progn
			    (search-backward ",[ \t]")
			    (forward-char)
			    (newline-and-indent))))))

	      ;; Add comments.
	      (let ((max 0))
		(while (re-search-forward ",[ \t]" nil t)
		  (backward-char)
		  (if (< max (current-column))
		      (setq max (current-column)))
		  (newline-and-indent))
		(goto-char end)
		  (if (< max (current-column))
		      (setq max (current-column)))
		  (setq max (+ 1 max))
		  (goto-char begin)
		  (let ((done nil))
		    (while (not done)
		      (end-of-line)
		      (move-to-column max t)
		      (insert "//")
		      (if (> (forward-line) 0)
			  (setq done t))))))
	    (widen)))))




; insert VMWare-style comment
(if (functionp 'fume-find-next-c-function-name)
    (defun vmware-comment ()
    "Inserts a VMWare-style comment for the function that follows the point"
      (interactive)
      (save-excursion
	(setq comment-funcname
	      (car (fume-find-next-c-function-name (buffer-name)))
	      )
	)
      (insert
       (concat "\
/*
 *-----------------------------------------------------------------------------
 *
 * " comment-funcname " --
 *
 *      XXX
 *
 * Results:
 *      XXX
 *
 * Side effects:
 *      XXX
 *
 *-----------------------------------------------------------------------------
 */

" )
       )

      (end-of-line -10)
      )
  (defun vmware-comment (name)
    "Inserts a vmware-style function comment. Prompts for function name."
  (interactive "sFunction name: ")
  (insert-string (concat "\
/*
 *-----------------------------------------------------------------------------
 *
 * " name " --
 *
 *      XXX
 *
 * Results:
 *      XXX
 *
 * Side effects:
 *      XXX
 *
 *-----------------------------------------------------------------------------
 */

"))
  (end-of-line -8)
))


(provide 'vmware)
