# Set some display-related env vars when in graphical environment so I can use
# fish to reliably launch graphical apps by using `fish -c "somecommand"`
if set -q XDG_CURRENT_DESKTOP
  set -x GTK_THEME Dracula
  # If using wayland, set appropriate env vars
  if set -q WAYLAND_DISPLAY
    set -x MOZ_ENABLE_WAYLAND 1
    set -x QT_QPA_PLATFORM 'wayland'
    set -x _JAVA_AWT_WM_NONREPARENTING 1
  end
  if test (command -s qt5ct)
    set -x QT_QPA_PLATFORMTHEME "qt5ct"
  end
end

if status is-interactive
  # Commands to run in interactive sessions can go here
  fish_vi_key_bindings
  fish_add_path /nix/var/nix/profiles/default/bin ~/.nix-profile/bin ~/.cargo/bin ~/go/bin ~/.local/bin
  fzf_configure_bindings --variables=\e\cE --history=\e\cR
  # Important environment variables
  set -x BROWSER "firefox"
  set -x EDITOR "nvim"
  set -x PAGER "less --chop-long-lines --RAW-CONTROL-CHARS"
  # For puppetdb work on my work machine
  set -x PDBBOX ~/tmp/pdb-sandbox
  set -x PUPPET_SUPPRESS_INTERNAL_LEIN_REPOS 1
  set -x PDB_TEST_KEEP_DB_ON_FAIL true
  # This sets the theme for bat and delta
  set -x BAT_THEME 'base16'
  # fzf dracula color scheme
  set -x FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
  # Aliases
  alias ll 'ls -l'
  alias la 'ls --almost-all'
  alias l 'ls -C --classify'
  alias gs 'git status'
  alias gl 'git fancy-log'
  alias glo 'git log --oneline'
  alias rm 'rm --interactive'
  alias mv 'mv --no-clobber'
  alias t 'tmux attach -t config; or tmux'
  alias beep "aplay --quiet ~/music/sound-effects/ding-ding.wav"
  alias alert 'notify-send "Terminal alert! 🐢"'
  alias cp "cp -n"
  # Like startx, start wayland, qt setting
  alias startw "exec ~/.config/scripts/start-sway.sh"
  # Debian installs batcat, Fedora installs bat
  if test (command -s batcat)
    alias bat 'batcat --theme=base16 --style=header'
  else
    alias bat 'bat --theme=base16 --style=header'
  end
  # Debian installs fdfind, Fedora installs bat
  if test (command -s fdfind)
    alias fd "fdfind"
  end
  # If python is not viable command and python3 is, make an alias
  if test (command -s python3) && not test (command -s python)
    alias python "python3"
  end
  alias r "rsync --archive --verbose --human-readable --progress --ignore-existing"
  alias s "source ~/.config/fish/config.fish && echo 'config reloaded ✨'"
  alias dl-base "yt-dlp --embed-metadata --embed-thumbnail --embed-subs --sub-langs 'en' --embed-chapters --sponsorblock-mark 'default' --sponsorblock-remove 'sponsor,selfpromo,outro' --download-archive 'archive.txt' --progress"
  alias dl-video "dl-base --format 'best[height<=720]'"
  alias dl-best-video "dl-base --format 'bestvideo+bestaudio'"
  alias dl-music "dl-base --format 'best[ext=mp3]' --output '%(title)s - %(album)s [%(id)s].%(ext)s'"
  alias dl-best-music "dl-base --format 'flac / best[ext=mp3]' --output '%(title)s - %(album)s [%(id)s].%(ext)s'"
  alias new-ssh-key "ssh-keygen -t ed25519 -C 'stel@stel.codes'"
  alias c "FZF_DEFAULT_COMMAND='fd --hidden --type d' cd (fzf)"
  alias noansi 'sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
  alias loggy 'noansi | tee ~/tmp/$(date +%F-%T)-log.txt'
  # Don't show cover art in separate window when playing music files
  alias mpv 'mpv --audio-display=no'

  # Make prompt
  starship init fish | source
end
