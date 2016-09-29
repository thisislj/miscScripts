 (require 'cl)
 (defun totd ()
  (interactive)
  (with-output-to-temp-buffer "*Tip of the day*"
    (let* ((commands (loop for s being the symbols
                           when (commandp s) collect s))
           (command (nth (random (length commands)) commands)))
      (princ
       (concat "Your tip for the day is:\n========================\n\n"
               (describe-function command)
               "\n\nInvoke with:\n\n"
               (with-temp-buffer
                 (where-is command t)
                 (buffer-string)))))))


;; org mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'highlight-80+)

;;(add-to-list 'load-path "~/.emacs.d/plugins")
;;(load "column-marker")
;;(add-hook 'foo-mode-hook (lambda () (interactive) (column-marker-1 80)))
;;(global-set-key "\C-cm" 'column-marker-1)

(defun my-horizontal-recenter ()
  "make the point horizontally centered in the window"
  (interactive)
  (let ((mid (/ (window-width) 2))
        (line-len (save-excursion (end-of-line) (current-column)))
        (cur (current-column)))
    (if (< mid cur)
        (set-window-hscroll (selected-window)
                            (- cur mid)))))
(global-set-key (kbd "C-S-l") 'my-horizontal-recenter)

(setq mode-require-final-newline nil)

;; move tmp files and backup files away
;;(defvar user-temporary-file-directory
;;  (concat temporary-file-directory user-login-name "/"))
(defvar user-temporary-file-directory "~/.emacs.d/backup")

(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.sc\\'" . python-mode))

; dont use tabs for indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

; remember
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-raise-tool-bar-buttons t t)
 '(auto-resize-tool-bars t t)
 '(calendar-week-start-day 1)
 '(case-fold-search t)
 '(inhibit-startup-screen t)
 '(load-home-init-file t t)
 '(make-backup-files nil)
 '(normal-erase-is-backspace nil)
 '(org-agenda-files (quote ("~/org/calenda/birthday.org" "~/org/calenda/newgtd.org")))
 '(org-agenda-ndays 14)
 '(org-agenda-repeating-timestamp-show-all nil)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-todo-ignore-deadlines t)
 '(org-agenda-todo-ignore-scheduled t)
 '(org-agenda-todo-ignore-with-date t)
 '(org-agenda-window-setup (quote other-window))
 '(org-deadline-warning-days 7)
 '(org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\">")
 '(org-fast-tag-selection-single-key nil)
 '(org-log-done (quote (done)))
 '(org-refile-targets (quote (("newgtd.org" :maxlevel . 1) ("someday.org" :level . 2))))
 '(org-reverse-note-order t)
 '(org-tags-column -78)
 '(org-tags-match-list-sublevels nil)
 '(org-time-stamp-rounding-minutes 5)
 '(org-use-fast-todo-selection t)
 '(org-use-tag-inheritance nil))

(autoload 'remember "remember" nil t)
(autoload 'remember-region "remember" nil t)

(setq org-directory "~/org/calenda/")
(setq org-default-notes-file "~/org/calenda/notes")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map "\C-cr" 'org-remember)

(setq org-remember-templates
     '(
      ("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/org/calenda/newgtd.org" "Tasks")
      ("Private" ?p "\n* %^{topic} %T \n%i%?\n" "~/org/calenda/privnotes.org")
      ("WordofDay" ?w "\n* %^{topic} \n%i%?\n" "~/org/calenda/wotd.org")
      ))

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
      '(
        ("P" "Projects" ((tags "PROJECT")))
        ("H" "Office and Home Lists"
         ((agenda) (tags-todo "filesystem") (tags-todo "vmsyslog") (tags-todo "vmsupport") (tags-todo "bc") (tags-todo "misc")))
        ("D" "Daily Action List"
         ((agenda ""
                  ((org-agenda-ndays 1)
                   (org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up))))
                   (org-deadline-warning-days 0))
         )))
        ("W" "Completed and/or deferred tasks from previous week"
         ((agenda "" (
            (org-agenda-span 14)
            (org-agenda-start-day "-14d")
            (org-agenda-entry-types '(:timestamp))
            (org-agenda-show-log t))
          )))
       ))

(defun gtd () (interactive) (find-file "~/org/calenda/newgtd.org") )
    (global-set-key (kbd "C-c g") 'gtd)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;;(set-variable 'confirm-kill-emacs 'yes-or-no-p)

(require 'fixme-mode)

;; publish
(require 'org-publish)
(setq org-publish-project-alist
      '(("org-notes"
         :base-directory "~/org/"
         :base-extension "org"
         :publishing-directory "/mts/home3/jianl/public_html/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4             ; Just the default for this project.
         :auto-preamble t
         :style-include-default nil
         :export-creator-info nil    ; Disable the inclusion of "Created by Org" in the postamble.
         :export-author-info nil     ; Disable the inclusion of "Author: Your Name" in the postamble.
        )
        ("org-static"
         :base-directory "~/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "/mts/home3/jianl/public_html/"
         :recursive t
         :publishing-function org-publish-attachment
        )
        ("org-todo"
         :base-directory "~/org/calenda/"
         :base-extension "org"
         :publishing-directory "/mts/home3/jianl/public_html/todo/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4             ; Just the default for this project.
         :auto-preamble t
         :style-include-default nil
         :export-creator-info nil    ; Disable the inclusion of "Created by Org" in the postamble.
         :export-author-info nil     ; Disable the inclusion of "Author: Your Name" in the postamble.
        )
        ("org-notes"
         :base-directory "~/org/notes/"
         :base-extension "org"
         :publishing-directory "/mts/home3/jianl/public_html/notes/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4             ; Just the default for this project.
         :auto-preamble t
         :style-include-default nil
         :export-creator-info nil    ; Disable the inclusion of "Created by Org" in the postamble.
         :export-author-info nil     ; Disable the inclusion of "Author: Your Name" in the postamble.
        )
        ("org" :components ("org-notes" "org-static" "org-todo" "org-done" "org-notes"))
       )
      )

;; white spaces
(require 'whitespace)
(setq whitespace-style
  '(lines-tail tabs tab-mark trailing))

;; disable sup/subscripting
(setq org-export-with-sub-superscripts nil)

;; cscope
(require 'xcscope)

;; vmware lib
(require 'vmware)

(setq make-backup-files nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'linum)
(global-linum-mode 1)

(require 'taglist)


;; Toggle window dedication
(defun toggle-window-dedicated ()
"Toggle whether the current active window is dedicated or not"
(interactive)
(message 
 (if (let (window (get-buffer-window (current-buffer)))
       (set-window-dedicated-p window 
        (not (window-dedicated-p window))))
    "Window '%s' is dedicated"
    "Window '%s' is normal")
 (current-buffer)))

(global-set-key [pause] 'toggle-window-dedicated)

(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "darkblue")
                                                                      
(setq fci-handle-truncate-lines nil)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(defun auto-fci-mode (&optional unused)
  (if (> (window-width) fci-rule-column)
      (fci-mode 1)
      (fci-mode 0))
  )
(add-hook 'after-change-major-mode-hook 'auto-fci-mode)
(add-hook 'window-configuration-change-hook 'auto-fci-mode)

(column-number-mode 1)        
