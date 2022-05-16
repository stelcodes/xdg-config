function countdown --description 'Sleep but with a countdown' --argument num
    if not string match --quiet --regex '^[0-9]+$' $num
        echo "Argument must be a number"
        return 1
    end
    while test $num -gt 0
        printf "\rCountdown: $num "
        sleep 1
        set num (math "$num - 1")
    end
    printf "\rCountdown ended!\n"
end
