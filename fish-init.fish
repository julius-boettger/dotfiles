# greeting (only in interactive shell)
function fish_greeting

    set key_color   $(shuf -n 1 -e cyan magenta blue yellow green red)
    set title_color $(shuf -n 1 -e cyan magenta blue yellow green red)
    set logo_color  $(shuf -n 1 -e cyan magenta blue yellow green red)
    fastfetch -c /etc/dotfiles/fastfetch/short.jsonc --color-keys $key_color --color-title $title_color --logo-color-1 $logo_color

    fortune -sn 200

    # use starship prompt
    starship init fish | source

end