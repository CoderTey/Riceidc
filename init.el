;; -*- lexical-binding: t; -*-
(require 'package)

;; --------------------------
;; Репозитории
;; --------------------------
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; --------------------------
;; Пути к бинарникам
;; --------------------------
(dolist (dir '("/usr/bin" "/bin" "/usr/local/bin"))
  (when (file-directory-p dir)
    (add-to-list 'exec-path dir)))
(setenv "PATH" (string-join exec-path path-separator))

;; --------------------------
;; Установка пакетов
;; --------------------------
(defun ensure-package (pkg)
  "Install PKG if not installed."
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; --------------------------
;; Тема
;; --------------------------
(ensure-package 'shades-of-purple-theme)
(load-theme 'shades-of-purple t)

;; --------------------------
;; Интерфейс
;; --------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(electric-pair-mode 1)

;; --------------------------
;; Evil-mode
;; --------------------------
(ensure-package 'evil)
(require 'evil)
(setq evil-want-C-u-scroll t)
(evil-mode 1)

;; --------------------------
;; Undo-tree
;; --------------------------
(ensure-package 'undo-tree)
(require 'undo-tree)
(global-undo-tree-mode 1)

;; --------------------------
;; Company (автодополнение)
;; --------------------------
(ensure-package 'company)
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

;; --------------------------
;; Eglot (LSP для C)
;; --------------------------
(ensure-package 'eglot)
(require 'eglot)
(add-hook 'c-mode-hook #'eglot-ensure)
(setq eglot-autoshutdown t)

;; --------------------------
;; Git (Magit)
;; --------------------------
(ensure-package 'magit)
(require 'magit)

;; --------------------------
;; Compile & Run C (F5)
;; --------------------------
(defun my-c-run ()
  "Compile and run current C file."
  (interactive)
  (save-buffer)
  (let* ((file (buffer-file-name))
         (output (concat (file-name-sans-extension file) ".out"))
         (gcc (or (executable-find "gcc")
                  (error "gcc not found in PATH")))
         (cmd (format "%s -Wall -Wextra -O2 %s -o %s && ./%s"
                      gcc file output (file-name-nondirectory output))))
    (compile cmd)))
(global-set-key (kbd "<f5>") 'my-c-run)

;; --------------------------
;; CMake Build (F6)
;; --------------------------
(ensure-package 'cmake-mode)
(require 'cmake-mode)

(defun my-cmake-build ()
  "Build project using CMake in 'build/' folder."
  (interactive)
  (let ((proj-root (or (projectile-project-root)
                       default-directory)))
    (unless (file-exists-p (concat proj-root "CMakeLists.txt"))
      (error "No CMakeLists.txt found in project root"))
    (compile (format "cmake -S %s -B %sbuild -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build %sbuild"
                     proj-root proj-root proj-root))))
(global-set-key (kbd "<f6>") 'my-cmake-build)

;; --------------------------
;; File associations
;; --------------------------
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.s\\'" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.asm\\'" . asm-mode))

;; --------------------------
;; ASM settings
;; --------------------------
(add-hook 'asm-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 8)))

;; --------------------------
;; Browser
;; --------------------------
(setq browse-url-browser-function 'browse-url-firefox)

;; --------------------------
;; Projectile
;; --------------------------
(ensure-package 'projectile)
(require 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; --------------------------
;; DAP (Debug)
;; --------------------------
(ensure-package 'dap-mode)
(require 'dap-mode)
(require 'dap-gdb-lldb)
(dap-auto-configure-mode 1)
(setq dap-auto-show-output t)
;; Treemacs
(ensure-package 'treemacs)
(require 'treemacs)

;; Показывать все файлы, включая скрытые
(setq treemacs-show-hidden-files t)

;; Открывать дерево на текущей директории Emacs
(defun my-treemacs-toggle-current-dir ()
  "Открыть Treemacs в текущей директории Emacs."
  (interactive)
  (let ((root default-directory))
    (unless (treemacs-get-local-window)
      (treemacs-add-project-to-workspace root root))
    (treemacs-select-window)))

;; Горячие клавиши
(global-set-key (kbd "C-c t") 'treemacs) ;; обычный toggle
(global-set-key (kbd "C-c T") 'my-treemacs-toggle-current-dir)

;; Дополнительно: сортировка по алфавиту и ширина панели
(setq treemacs-width 30
      treemacs-indentation 2
      treemacs-sorting 'alphabetic-asc
      treemacs-is-never-other-window t)

