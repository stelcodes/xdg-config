if status is-interactive
  # Commands to run in interactive sessions can go here
  fish_vi_key_bindings
  fish_add_path --path --prepend ~/.local/bin ~/.cargo/bin ~/go/bin
  fzf_configure_bindings --variables=\e\cE --history=\e\cR
  # Important environment variables
  set -x BROWSER "firefox"
  set -x EDITOR "nvim"
  set -x QT_QPA_PLATFORMTHEME "qt5ct"
  if [ -e ~/sync/secrets/openweathermap-api-key ]
    set -x OPENWEATHERMAP_API_KEY (cat ~/sync/secrets/openweathermap-api-key)
  end
  # For puppetdb work on my work machine
  set -x PDBBOX ~/tmp/pdb-sandbox
  set -x PUPPET_SUPPRESS_INTERNAL_LEIN_REPOS 1
  set -x PDB_TEST_KEEP_DB_ON_FAIL true
  # This sets the theme for bat and delta
  set -x BAT_THEME 'base16'
  if test $WAYLAND_DISPLAY
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
  end
  # Aliases
  alias ll='ls -l'
  alias la='ls --almost-all'
  alias l='ls -C --classify'
  alias gs='git status'
  alias gl='git fancy-log'
  alias glo='git log --oneline'
  alias rm='rm --interactive'
  alias mv='mv --no-clobber'
  alias t='tmux attach -t config; or tmux'
  alias beep="aplay --quiet ~/music/sound-effects/ding-ding.wav"
  alias alert='notify-send "Terminal alert! 🐢"'
  alias cp="cp -n"
  # Like startx, start wayland, qt setting
  alias startw="exec ~/.config/scripts/start-sway.sh"
  # Debian installs batcat, Fedora installs bat
  if command -s batcat &> /dev/null
    alias bat='batcat --theme=base16 --style=header'
  else
    alias bat='bat --theme=base16 --style=header'
  end
  # Debian installs fdfind, Fedora installs bat
  if command -s fdfind &> /dev/null
    alias fd="fdfind"
  end
  # If python is not viable command and python3 is, make an alias
  if ! command -s python &> /dev/null && command -s python3 &> /dev/null
    alias python "python3"
  end
  alias r "rsync --archive --verbose --human-readable --progress --ignore-existing"
  alias s "source ~/.config/fish/config.fish && echo 'config reloaded ✨'"
  alias dl-base "yt-dlp --embed-metadata --embed-thumbnail --embed-subs --sub-langs 'en' --embed-chapters --add-header 'User-Agent:Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'"
  alias dl-small-video "dl-base --format 'best[height<=720]'"
  alias dl-best-video "dl-base --format 'bestvideo+bestaudio'"
  alias dl-small-audio "dl-base --format 'best[ext=mp3]'"
  alias dl-best-audio "dl-base --format 'flac,alac,best[ext=mp3],ogg,best'"
  alias new-ssh-key "ssh-keygen -t ed25519 -C 'stel@stel.codes'"

  # Make prompt
  starship init fish | source
end
