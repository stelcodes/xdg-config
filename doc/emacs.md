emacs --daemon (run from home dir)

emacsclient -c

meta-x: interactive. quick repl where you can invoke a function interactively for something that doesn't have key presses especially

ctrl-h: help
  t: tutorial

ctrl-space: set mark
  then scroll for selection

ctrl-g: stop doing this thing

minibuffer is the line(s) at the bottom

meta-x list-packages

`info emacs` <ctrl-s> search for something <cr>

meta-x apropos

ctrl-y paste into emacs

ctrl-k kill line (cut) (press twice to cut newline too)

meta-x eval-region for eval interactive

meta-x kill-emacs

meta-x grep
meta-x compile
(use ctrl-backtick to cycle through references)
(grep mode and compile mode are very similar)

ctrl-x b (switch buffer)

ctrl-x ctrl-f (open file)

ctrl-x 1 (only window)
ctrl-x 2 (split vertically)
ctrl-x 3 (split horizontally)
ctrl-x 0 (close window)

Ido mode:
ctrl-s (cycle)

Saving files:
ctrl-x ctrl-s (save file)
If the mode line has asterisks, the buffer is dirty

Reload buffer:
ctrl-x ctrl-v (replace contents of buffer with another file, original file by default)

sudo apt install fonts-hack
meta-x set-frame-font hack-12

ctrl-x ctrl-d (list dir)

ctrl-x ctrl-f ctrl-d (ido mode list dir)

ctrl-h a (search for pattern in help)

c-x o (focus to different buffer in window)
