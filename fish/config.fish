if status is-interactive
  # Commands to run in interactive sessions can go here
  starship init fish | source
  fish_add_path --path --append ~/.local/bin ~/.cargo/bin ~/go/bin
  # Important environment variables
  set -x BROWSER "firefox"
  set -x EDITOR "nvim"
  set -x QT_QPA_PLATFORMTHEME "qt5ct"
  if [ -e ~/sync/secrets/openweathermap-api-key ]
    set -x OPENWEATHERMAP_API_KEY (cat ~/sync/secrets/openweathermap-api-key)
  end
  # Aliases
  alias ll='ls -l'
  alias la='ls -A'
  alias l='ls -CF'
  alias gs='git status'
  alias gl='git fancy-log'
  alias glo='git log --oneline'
  alias rm='rm -i'
  alias mv='mv -n'
  alias t='tmux attach -t config; or tmux'
  alias beep="aplay --quiet ~/music/sound-effects/ding-ding.wav"
  alias alert='notify-send "Terminal alert! 🐢"'
  alias cp="cp -n"
  # Like startx, start wayland, qt setting
  alias startw="exec ~/.config/scripts/start-sway.sh"
  # Debian installs batcat, Fedora installs bat
  if command -s batcat &> /dev/null
    alias bat='batcat --theme=base16 --plain'
  else
    alias bat='bat --theme=base16 --plain'
  end
  # Debian installs fdfind, Fedora installs bat
  if command -s fdfind &> /dev/null
    alias fd="fdfind"
  end
  alias r "rsync -avv --progress"
  alias s "source ~/.config/fish/config.fish && echo 'config reloaded ✨'"
end
