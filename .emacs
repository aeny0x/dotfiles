(setq custom-file "~/.emacs.d/emacs-custom.el")
(setq inhibit-startup-screen t)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)

(set-frame-font "Iosevka 13" nil t)
(global-display-line-numbers-mode)
(toggle-frame-fullscreen)

(load-file custom-file)
