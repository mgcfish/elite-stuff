;;; elite-mode.el --- Elite mode.
;;
;; Author: Sliim <sliim@mailoo.org>
;; Version: 1.0.0

;; This file is not part of GNU Emacs.

(require 'helm-mode)
(require 'msf)
(require 'msf-hosts)
(require 'msf-services)
(require 'msf-sessions)
(require 'msf-routes)
(require 'msf-consoles)
(require 'msf-jobs)
(require 'msf-threads)
(require 'msf-workspaces)
(require 'msf-notes)
(require 'msf-creds)
(require 'msf-vulns)
(require 'msf-loots)
(require 'msf-modules)
(require 'helm-h4x0r)
(require 'exploitdb)
(require 'popwin)
(require 'alert)

(defvar elite-mode-hook nil)

(defvar elite-mode-map
  (let ((map (make-keymap)))
    (define-key map "f" 'helm-msf-files)
    (define-key map "h" 'helm-msf-hosts)
    (define-key map "s" 'helm-msf-services)
    (define-key map "S" 'helm-msf-sessions)
    (define-key map "r" 'helm-msf-routes)
    (define-key map "c" 'helm-msf-consoles)
    (define-key map "C" 'msfrpc-create-new-console)
    (define-key map "j" 'helm-msf-jobs)
    (define-key map "t" 'helm-msf-threads)
    (define-key map "w" 'helm-msf-workspaces)
    (define-key map "n" 'helm-msf-notes)
    (define-key map "p" 'helm-msf-creds)
    (define-key map "v" 'helm-msf-vulns)
    (define-key map "l" 'helm-msf-loots)
    (define-key map "m" 'helm-msf-modules)
    (define-key map "x" 'helm-searchsploit)
    (define-key map "q" 'kill-this-buffer)
    (define-key map "H" 'helm-h4x0r)
    (define-key map "I" 'elite-teamserver-infos)
    (define-key map "R" 'elite-mode)
    (define-key map (kbd "o e") 'msf>read-opts)
    (define-key map (kbd "o c") 'msf>clear-opts)
    (define-key map (kbd "b s") 'elite-save-buffers)
    map)
  "Keymap for Elite major mode")

(add-to-list 'auto-mode-alist '("*elite-mode*" . elite-mode))

(defun elite-mode ()
  "The Elite mode"
  (interactive)
  (let ((bufname "*elite-mode*"))
    (get-buffer-create bufname)
    (switch-to-buffer-other-window bufname)
    (with-current-buffer bufname
      (erase-buffer)
      (insert "Emacs Elite Mode\n")
      (insert "================\n")
      (insert (concat "\n TeamServer: [" (getenv "MSFRPC_HOST") ":" (getenv "MSFRPC_PORT") "]\n"))
      (insert "----------------------\n")
      (insert "R - Refresh  |  I - TeamServer Infos |  C - Create console\n")
      (insert "\n")
      (insert "w - Workspaces  |  h - Hosts    |  s - Services\n")
      (insert "n - Notes       |  v - Vulns    |  p - Creds\n")
      (insert "j - Jobs        |  t - Threads  |  c - Consoles\n")
      (insert "S - Sessions    |  r - Routes   |  l - Loots\n")
      (insert "m - Modules\n")
      (insert "\n")
      (insert ">Options\n")
      (insert "o e - Edit options  |  o c - Clear options\n")
      (insert "Current:")
      (insert (msf>render-opts msf/user-opts))
      (insert "\n---------------\n")
      (insert "\n")
      (insert "\n Metasploit Local files\n")
      (insert "----------------------\n")
      (insert "f - Local files\n")
      (insert "\n Elite Stuff\n")
      (insert "----------\n")
      (insert "x - Search Sploit |  H - H4x0r Stuff\n")
      (insert "b s - Save All Buffers\n")
      (insert "\n")
      (insert "q - Quit\n")
      (kill-all-local-variables)
      (setq major-mode 'elite-mode)
      (setq mode-name "Elite")
      (use-local-map elite-mode-map)
      (run-hooks 'elite-mode-hook))))

(defun elite-teamserver-infos ()
  "Show TeamServer Infos notification."
  (interactive)
  (alert (concat "Elite mode started\n" (shell-command-to-string "msf-infos;echo;msf-status")) :title "EliteStuff" :category 'pwnage))

(defun elite-update-mode-line ()
  "Update elite mode-line"
  (message "Updating mode-line..")
  (setq-default mode-line-format
        (list
         (shell-command-to-string "msf-mode-line")
         minor-mode-alist))
  (message "Done."))

(defun elite-save-buffers ()
  "Save all buffers in elite-mode."
  (interactive)
  (dolist (b (buffer-list))
    (set-buffer b)
    (if (not (string-match "^ ?\\*" (buffer-name)))
        (write-file (buffer-name)))))

(run-at-time 0 60 'elite-update-mode-line)
(push '("*elite-mode*" :stick t :height 35 :position top) popwin:special-display-config)

(provide 'elite-mode)
