;;; modeline-char.el --- In the mode-line, show the value of the character after point.
;;
;; Filename: modeline-char.el
;; Description: In the mode-line, show the value of the character after point.
;; Author: Drew Adams
;; Maintainer: Drew Adams (concat "drew.adams" "@" "oracle" ".com")
;; Copyright (C) 2015, Drew Adams, all rights reserved.
;; Created: Tue Jul  7 10:52:36 2015 (-0700)
;; Version: 0
;; Package-Requires: ()
;; Last-Updated:
;;           By:
;;     Update #: 137
;; URL: http://www.emacswiki.org/modeline-char.el
;; Doc URL: http://www.emacswiki.org/emacs/ModeLineCharacterInfo
;; Keywords: mode-line, character
;; Compatibility: GNU Emacs: 22.x, 23.x, 24.x, 25.x
;;
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;  In the mode-line, show the value of the character after point.
;;
;;  Use minor mode `mlc-char-in-mode-line-mode' to show the value of
;;  the character after point.  Use global minor mode
;;  `mlc-char-in-mode-line-mode-global' to do this in every buffer.
;;
;;
;;  Commands defined here:
;;
;;    `mlc-char-in-mode-line-mode', `mlc-char-in-mode-line-mode-global'.
;;
;;  Faces defined here:
;;
;;    `mlc-mode-line-char-format', `mlc-mode-line-char-format-code'.
;;
;;  Non-interactive functions defined here:
;;
;;    `mlc-turn-on-char-in-mode-line-mode'.
;;
;;  Internal variables defined here:
;;
;;    `mlc-mode-line-char-format',
;;    `mlc-char-in-mode-line-mode-initialized'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;; 2015/07/10 dadams
;;     Created.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(defface mlc-mode-line-char-format
  '((t (:foreground "Red" :background "LightGreen")))
  "Mode-line face for character after point."
  :group 'Modeline)

(defface mlc-mode-line-char-format-code
  '((t (:foreground "Blue")))
  "Mode-line face for code point of character after point."
  :group 'Modeline)

;;;###autoload (put 'mlc-mode-line-char-format 'risky-local-variable t)
(defvar mlc-mode-line-char-format
  '(:eval (and mlc-char-in-mode-line-mode
           (let* ((ch   (following-char))
                  (str  (format (if (= ?% ch) "[%%%c=%06x] " "[%c=%06x] ") ch ch))
                  (map  (make-sparse-keymap)))
             (define-key map [down-mouse-2] nil)
             (define-key map [mouse-2] (lambda (ev) (interactive "e") (describe-char (point))))
             (add-text-properties 1 2                  '(face mlc-mode-line-char-format) str)
             (add-text-properties 3 (- (length str) 2) '(face mlc-mode-line-char-format-code) str)
             (add-text-properties 1 (- (length str) 2) `(mouse-face mode-line-highlight
                                                                    help-echo "mouse-2: more info about char"
                                                                    local-map ,map) ; See Emacs bug #21033.
                                  str)
             str)))
  "Mode-line format spec to display a character.")

(defvar mlc-char-in-mode-line-mode-initialized nil
  "Non-nil if `mlc-char-in-mode-line-mode' has been called.")

;;;###autoload
(define-minor-mode mlc-char-in-mode-line-mode
  "Show char after point in mode line, at start of `global-mode-string'."
  nil nil nil :group 'Modeline
  (unless mlc-char-in-mode-line-mode-initialized
    (setq mlc-char-in-mode-line-mode-initialized  t)
    (setq global-mode-string  (cond ((consp global-mode-string)
                                     (add-to-list 'global-mode-string mlc-mode-line-char-format))
                                    ((not global-mode-string)
                                     (list mlc-mode-line-char-format))
                                    ((stringp global-mode-string)
                                     (list mlc-mode-line-char-format global-mode-string))))))

(defun mlc-turn-on-char-in-mode-line-mode ()
  "Turn on `mlc-char-in-mode-line-mode'."
  (mlc-char-in-mode-line-mode 1))

;;;###autoload
(define-globalized-minor-mode mlc-char-in-mode-line-mode-global
    mlc-char-in-mode-line-mode mlc-turn-on-char-in-mode-line-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'modeline-char)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; modeline-char.el ends here
