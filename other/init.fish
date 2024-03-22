# greeting (only in interactive shell)
function fish_greeting
    set key_color   $(shuf -n 1 -e cyan magenta blue yellow green red)
    set title_color $(shuf -n 1 -e cyan magenta blue yellow green red)
    set logo_color  $(shuf -n 1 -e cyan magenta blue yellow green red)
    fastfetch-short --color-keys $key_color --color-title $title_color --logo-color-1 $logo_color
    fortune -sn 200
end

# other stuff to do only in interactive shells
if status is-interactive
    # setup zoxide to provide z as better cd
    zoxide init fish | source
    # use starship prompt
    starship init fish | source
    # aliases
    alias cd z
    alias ls lsd
    alias cat bat
end

# use like "flake-rebuild HOST [--impure]"
function flake-rebuild
    # use "desktop" for $argv if not provided
    if test "x$argv" = "x"
        set argv desktop
    end
    # cd back and forth because of wsl issue
    set workingDir $(pwd)
    cd /etc/dotfiles/nix
    eval "sudo nixos-rebuild switch --flake .#$argv"
    cd $workingDir
end