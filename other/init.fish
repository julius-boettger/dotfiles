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

    ### aliases
    alias cd z
    alias ls lsd
    alias cat bat
    alias aquarium "asciiquarium --transparent"
    # alias some nix commands to nom (for prettier output)
    function nix
        if begin test "$argv[1]" = "shell";
              or test "$argv[1]" = "develop";
              or test "$argv[1]" = "build";
            end
            nom $argv
        else
            # use command to avoid recursion of this function
            command nix $argv
        end
    end
end

# use like "flake-rebuild [--impure] [(other options)]"
function flake-rebuild
    # exit with error message if default host is not set
    if test "x$NIX_FLAKE_DEFAULT_HOST" = "x"
        set_color red
        echo -n "error: "
        set_color normal
        echo '$NIX_FLAKE_DEFAULT_HOST is not set!'
        return
    end
    # cd back and forth because of wsl issue
    set workingDir $(pwd)
    cd /etc/dotfiles/nix
    # require users password to continue
    # (to avoid nom not showing password prompt for nixos-rebuild)
    sudo true # require password to do nothing
    if test $status -ne 0; return; end # exit if unsuccessful

    # use default host and nom for prettier output
    eval "sudo nixos-rebuild switch --flake .#$NIX_FLAKE_DEFAULT_HOST $argv &| nom"

    # go back
    cd $workingDir
end