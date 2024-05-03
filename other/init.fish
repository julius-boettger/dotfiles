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
    alias flake-update "/etc/dotfiles/nix/update/update.sh"
    # alias some nix commands 
    function nix
        # to nom (prettier output)
        if begin test "$argv[1]" = "shell";
              or test "$argv[1]" = "develop";
              or test "$argv[1]" = "build";
            end
            nom $argv
        # to nh (prettier, faster and more convenient)
        else if test "$argv[1]" = "search"
            nh $argv
        # to original
        else
            # use "command" to avoid recursion of this function
            command nix $argv
        end
    end
end

# use like "flake-rebuild [--impure] [(other options)]"
function flake-rebuild
    # exit with error message if current device is not set
    if test "x$NIX_FLAKE_CURRENT_DEVICE" = "x"
        set_color red
        echo -n "error: "
        set_color normal
        echo '$NIX_FLAKE_CURRENT_DEVICE is not set!'
        return 1
    end
    # cd back and forth because of wsl issue
    set workingDir $(pwd)
    cd /etc/dotfiles/nix
    # use --impure if NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT is set
    if test "$NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT" = "1"
        set impure "--impure"
    end

    # rebuild with nh (for prettier output), current device,
    # --impure (if set) and other given args
    nh os switch -H $NIX_FLAKE_CURRENT_DEVICE . -- $impure $argv

    set return_code $status
    # go back
    cd $workingDir
    # return status code of nh os switch
    return $return_code
end