function fish_greeting
  # To skip, unassign fish_greeting
  if not set -q fish_greeting
      set -g fish_greeting (printf (_ '🐟 don\'t be afraid to ask for %shelp%s 💞') (set_color green) (set_color normal))
  end

  if set -q fish_private_mode
      set -l line (_ "😈 commencing private mode")
      if set -q fish_greeting[1]
          set -g fish_greeting $fish_greeting\n$line
      else
          set -g fish_greeting $line
      end
  end

  # The greeting used to be skipped when fish_greeting was empty (not just undefined)
  # Keep it that way to not print superfluous newlines on old configuration
  test -n "$fish_greeting"
  and echo $fish_greeting
end
