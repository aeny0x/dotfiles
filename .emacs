;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; GLOBAL VARIABLES
(setq custom-file "~/.emacs.d/emacs-custom.el")
(setq make-backup-files nil)
(setq inhibit-startup-screen t)
(setq treesit-font-lock-level 4)

;; MISC
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(add-to-list 'default-frame-alist `(font . "Iosevka-15"))
(ido-mode 1)
(split-window-horizontally)
(toggle-frame-fullscreen)
(set-fringe-mode -1)

(setq treesit-language-source-alist
      '((scala "https://github.com/tree-sitter/tree-sitter-scala" "v0.20.3")))

;; Fix scala output on compilation mode.
;; Also setting SCALA_COLORS=false on .bashrc should yield the same results.
(require 'ansi-color)
(defun colorize-compile-mode ()
  (ansi-color-apply-on-region compilation-filter-start (point)))

(add-hook 'compilation-filter-hook 'colorize-compile-mode)

;; simple function to highlight @TODO
(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil
             '(("\\(@\\(?:todo\\|TODO\\)\\)" 1 'font-lock-warning-face t)))
            (font-lock-flush)))

;; Whitespace mode
(defun set-whitespace-mode ()
  (interactive)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'scala-ts-mode-hook 'set-whitespace-mode)

;; NAVIGATION
(defun switch-c-h ()
  "Switch between corresponding .c and .h files in the same directory.
   If current buffer is foo.c, try to open foo.h; if foo.h, try to open foo.c.
   If no matching file exists, show a message."
  (interactive)
  (let* ((file (buffer-file-name)))
    (unless file
      (user-error "Buffer has no associated file"))
    (let* ((dir  (file-name-directory file))
           (base (file-name-sans-extension (file-name-nondirectory file)))
           (ext  (downcase (or (file-name-extension file) "")))
           (target (cond
                    ((string= ext "c") (concat dir base ".h"))
                    ((string= ext "h") (concat dir base ".c"))
                    (t nil))))
      (if (not target)
          (user-error "Not a .c or .h file")
        (if (file-exists-p target)
            (find-file target)
          (message "No matching file found: %s" (file-name-nondirectory target)))))))

(global-set-key (kbd "C-c o") #'switch-c-h)
(global-set-key (kbd "M-f") #'find-file-other-window)

(load-file custom-file)
