(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;;load-path設定
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/ruby")
(add-to-list 'load-path "~/.emacs.d/ruby/rhtml")
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(add-to-list 'load-path "~/.emacs.d/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/org-mode/contrib/lisp")

;;color-theme
(load-theme 'arjen t t)
(enable-theme 'arjen)

;;window分割設定
(add-hook 'after-init-hook (lambda()
    (setq w (selected-window))
    (setq w2 (split-window w nil t))
    (setq w3 (split-window w2 (- (window-height w2) 10)))
    (select-window w3)
    (eshell)
    (select-window w)))

;;メニューバー等非表示
(menu-bar-mode -1)
(setq inhibit-startup-message t)

;;CTRL+Hにバックスペース割り当て
(global-set-key "\C-h" 'delete-backward-char)

;;括弧をハイライト
(show-paren-mode 1)
(set-face-background 'show-paren-match "dark slate blue")
(set-face-foreground 'show-paren-match "gray90")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;;80文字で色変更
(add-hook 'ruby-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("^[^\n]\\{80\\}\\(.*\\)$" 1 font-lock-warning-face t)))))

;;tab設定
(setq-default tab-width 2 indent-tabs-mode nil)

;;改行時にインデント
(global-set-key "\C-m" 'newline-and-indent)

;;保存時に行末の空白削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;ファイル名に大文字小文字区別なし
(setq completion-ignore-case t)

;;バッファ自動読み込み
(global-auto-revert-mode 1)

;;Backup File を退避
(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/backup"))
    backup-directory-alist))

;;行番号を表示
(require 'linum)
(global-linum-mode t)
(setq linum-format "%3d")

;;現在行をハイライト
(setq hl-line-face 'highline-face)
(global-hl-line-mode)

;;flycheck
(require 'flycheck)
(add-hook 'ruby-mode-hook 'flycheck-mode)

;;org-mode
(setq org-log-done 'time)

;;markdown-mode
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;;scss-mode
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(defun scss-custom ()
  "scss-mode-hook"
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)
   )
  )
(add-hook 'scss-mode-hook
          '(lambda() (scss-custom)))

;;smart-newline mode
(require 'smart-newline)
(define-key global-map (kbd "RET") 'smart-newline)

;;yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;twittering-mode
(require 'twittering-mode)
(setq twittering-status-format "%FACE[font-lock-doc-string-face]{================================================================================}\n %FACE[font-lock-reference-face]{%S} %FACE[blue]{@%s} %p %FACE[font-lock-comment-face]{%RT{%s がリツイート}\n} %T \n %FACE[font-lock-comment-face]{%@}")
(setq twittering-use-master-password t)
(setq twittering-private-info-file "~/.emacs.d/twittering-mode.gpg")
(setq twittering-icon-mode t)
(setq twittering-timer-interval 60)
(setq twittering-number-of-tweets-on-retrieval 50)
(setq twittering-initial-timeline-spec-string
      '(":home"
        "unhappychoice/friends"
        ":replies"))
;;php
(require 'php-mode)

;;ruby
(require 'ruby-mode)
(require 'ruby-end)
(require 'ruby-block)
(require 'rhtml-mode)
(require 'rcodetools)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)
                ("[Rr]akefile" . ruby-mode)
                ("\\.rake$" . ruby-mode)
                ("\\.ru$" . ruby-mode)
                ("Gemfile" . ruby-mode))
              auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.erb$" . rhtml-mode))
                auto-mode-alist))
(add-to-list 'hs-special-modes-alist
             '(ruby-mode
               "\\(def\\|if\\|unless\\|begin\\|do\\|class\\|module\\|{\\)"
               "\\(end\\|}\\)"
               "#"
               (lambda (arg) (ruby-end-of-block)) nil))
(global-set-key "\C-c\C-d" 'xmp)

;;auto-complete-mode
(require 'auto-complete-config)
(ac-config-default)

;;git-gutter-mode
(require 'git-gutter)
(let ((hook))
  (dolist (hook
           '(emacs-lisp-mode-hook
             java-mode-hook
             c-mode-common-hook
             python-mode-hook
             php-mode-hook
             ruby-mode-hook
             rhtml-mode-hook
             js2-mode-hook
             css-mode-hook
             apples-mode-hook))
    (add-hook hook 'git-gutter-mode)))

;;whitespace-mode
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")
(setq whitespace-action '(auto-cleanup))
(global-whitespace-mode 1)
(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)

;;hideshow mode
(let ((hook))
  (dolist (hook
           '(emacs-lisp-mode-hook
             java-mode-hook
             c-mode-common-hook
             python-mode-hook
             php-mode-hook
             ruby-mode-hook
             rhtml-mode-hook
             js2-mode-hook
             css-mode-hook
             apples-mode-hook))
    (add-hook hook 'hs-minor-mode)))

(global-set-key "\C-t" 'hs-toggle-hiding)
(global-set-key "\M-t" 'hs-hide-all)

;;wakatime mode
(global-wakatime-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b72814a093d5ba6bb1000a3bb545fe38e432a92a39998f35bccebfa682d8f0f5" "63f85c5b69255ac37dd818ea0a2db937ff7acc32383690c44c4dbee1f56b1792" "9673d919d82ba115652cd688f752824d55e7a8767339860d830837749ba82e34" "75f741dd8303c3f5e8cfc6832d9b652e8d0901795737af33613035efa45f96df" "4c4f2d014a35339c3c83f42d71364a57fc0f8d1a30ff796e311db244a76ad83e" "a1e4fe54db25a6ebb9b0b3e52cb842bfdd5eba59b3befb70a5b6ee9894892c79" "a1d3f56656b4d6b6c3e8ce55a2732160534cdef284ea874beb0c15c5e48b9b6c" "ed7a3608e58c0fec3a7c37f340dddb3e091ca459b7d9baed226b41f87b523244" "37f6af0aa3525a2db7bedb0bee53786418e73296dd767c6d753fe83c5d0ac8e8" "924db2337d3fc42066fe5f3d94834af2889fc8f5c0c22c7a423ab75d1975e626" "c3f767056632f3473d5ea36049250f9a231cb69097febda686d23923bdc4f6fe" "37cc577960e76eb81bd9e6c0113bca1b208e1f3c59130d28e7eb30e2910e51d3" "036248553639c72f6f20a93326d0015c1698bb234eabcf1ba98465b3ae15733a" "8c8f0345dd197f66a981152cdd33da7b8318a4f2748cd8d45dbc3962f571927e" "954e20168a944d8cad59ecf8307648af52e2ac5ae2f2bc0cf050d462e86689fc" "7be99de0d42bd2f4986e0e45b9943ab59284be8eada9d7d90b4703aa2eb4ce7b" "f71aeb6a2900c7839f1302156bc5713c9569c8d18e7fec469a834cc56c13d645" "4c9bd2af3327dde796ce75d84c6716909eeaba8256f7bdc1d4439ca2abab1a96" "0a3bee2affe71fcbb1eaf39126a317fb974ffa67c2dece94c0b1e11a0b50d3b5" "d2c61f3ddceaf9892e193e87f5dc4d97609e4a95271ac430f4baa7286c431451" "1be9ccd7eba0aa521ae7bb40931f07de01e447b6d75b63c3a2ff2fce92ba8dc7" "696a2b539d8768fc45c7c358d92185cdce4737312f86e816631b3d6a69ef7e21" "1fe3eaf6aa6413ecc28cb4a93bdf413cfc6ac2846fcdccdd47c198b701dd80b2" "332199417fd8c3825240d4ed4cb152fa1607e2dfe302c25d0be1dc4c22def512" "cd66d25320038499b14420d2eb46d9c6f368695180fb4ef3cc3721c11dbb520c" "fc60471fdb7b5924eb7df12e3140939de747ab737f26c2761da8f79be723817d" "68d2a7fa3d9fd0b241aaf221aa2dbb42c4c73fd19614d74a94d3d953d0398275" "d2e7b810ffc32fea2904e89b45e1e14bbbbe1290e5b23e86a9e990e4d0c12d59" "242c62562a363f1f8238ed3578c74ed4d5a61a41dc8d46bea0eb7a15a76c9105" "0ef0f13ddc3211613c078cd31af2e27d73bff09fb2df16eb634979703e406b2d" "91a7882b24e7b92b88062d002819582e86ac7e75f629ee01edecdcb986d9ba74" "e11a31ccb2ba62d23394894eff5408ac4d579595423048796da8309707e3cd4e" "f52ecd8be8794f5b9b6cd5a0ed9bcc3df87eddf743d1f55dc392b422ea31196d" "ce383f7828076d38e8f0a30b36c1bc44b0d1222e67164e1f4ac4997abc47fb0a" "ff5a15ed0cf8be98bd2efb6d6159b4f4e8f3c61ec575b44bd9757258d3ff875d" "f807e78497f41db2048c86301e3a2e9909605ef6c6ea822761f2f323c8a905b3" "4dec76a303500dfc38ba175d99b29a1fe7e79b2d395a681d4ee59915b83bfc9f" "6c57adb4d3da69cfb559e103e555905c9eec48616104e217502d0a372e63dcea" "af3c625adcdea3d103e6d6c5f11d311c2c820b922a07020422cac821cf8f856f" "8e786eb410e14fcd9cd13c8ef50ba1e7c87dc8765f09b392a687792a7d4f1f57" "17f0e8c7e50282f65e5a38b0ababcb825c69e5d8cc16018d432a0b0334fbd821" "146a522bfaa6b94e9cdb25e88fd65b543b3e056e3323cba2f9ae835f93587eb4" "3aefd29d5c27c835fd0acbc4f9615bfa207faeb61c97abf0c533553c06ce7c12" "1894297301a641dbb88f1838c05bd96303038ec5cd46a572bdb1381142b425aa" "de614174b487a9cf8c481f7d27c83ea525e4350adc26c6271ffe60704b2aa0c1" "0d951a5e1b979ff72373cefaf590cf19e3074be68fc8da33bf970170d21268cf" "b9b5898a14724b4d95c198cf6281e3af893c9d694376e58a9a4d2a44afef4b5f" "acaf992dfefd951a358d1f61fbe7b559a202299bd3a74f80aa3214a6ae11e158" "004a95c4f728a824f6768ac1a5f504d9554a0acd822b46f9f25615857fd1a1c5" "91651e2688a6df03a700c7929c299bd6845b4641b785487c51dbfc24ed85b036" default)))
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(wakatime-api-key "874ceb56-ab9a-4b50-907d-be5b4725ee16")
 '(wakatime-cli-path ""))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-error ((t (:foreground "#999999" :underline (:color "#ee3333" :style wave)))))
 '(flycheck-info ((t (:background "#333333"))))
 '(font-lock-doc-string-face ((t (:foreground "chocolate"))) t)
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold :foreground "color-95"))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold :foreground "color-94"))))
 '(linum ((t (:inherit (shadow default) :background "gray10" :foreground "chocolate")))))
(put 'set-goal-column 'disabled nil)
