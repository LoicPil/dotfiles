(global-display-line-numbers-mode 1)
(defun copy-to-clipboard ()
  "Copy the selected region to the Wayland clipboard using wl-copy."
  (interactive)
  (if (region-active-p)
      (progn
        (shell-command-on-region (region-beginning) (region-end) "wl-copy")
        (message "Copied to clipboard"))
    (message "No region selected")))

(global-set-key (kbd "C-c C-a") 'copy-to-clipboard)
(defun wl-paste()
  "Paste from the Wayland clipboard using wl-paste."
  (shell-command-to-string "wl-paste"))
(when (executable-find "wl-copy")
  (setq interprogram-paste-function 'wl-paste)
  (setq interprogram-cut-function 'wl-copy))


