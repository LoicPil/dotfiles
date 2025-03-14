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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
