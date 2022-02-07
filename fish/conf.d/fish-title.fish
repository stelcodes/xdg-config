function fish_title
    set -q argv[1]; or set argv fish
    echo (string split ' ' $argv[1])[1];
end

