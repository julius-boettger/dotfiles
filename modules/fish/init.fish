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

    ### vim
    fish_vi_key_bindings
    set fish_vi_force_cursor
    set fish_cursor_insert line
    ### keybinds for default/visual mode
    bind -M default ö beginning-of-line
    bind -M visual  ö beginning-of-line
    bind -M default ä end-of-line
    bind -M visual  ä end-of-line
    ### keybinds for insert mode
    # ctrl+c => switch to default mode
    bind -M insert -m default \cc repaint-mode
    # ctrl+backspace => delete input
    bind -M insert \b kill-whole-line
    # ctrl+space => go through options
    bind -M insert -k nul complete
    # tab => accept suggestion
    bind -M insert \t accept-autosuggestion

    ### aliases
    alias cd z
    alias ls lsd
    alias cat bat
    alias aquarium "asciiquarium --transparent"
    alias flake-update "/etc/dotfiles/misc/update/update.sh"
    # easier numbat access
    function calc
        numbat -e "$argv"
    end
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
    
    # use --impure if NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT is set
    if test "$NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT" = "1"
        set impure "--impure"
    end

    # rebuild with nh (for prettier output), current device,
    # --impure (if set) and other given args
    nh os switch -H $NIX_FLAKE_CURRENT_DEVICE /etc/dotfiles -- $impure $argv
    return $status
end

# like flake-rebuild, but for remote rebuilds
# use like "flake-rebuild-remote HOSTNAME [--impure] [(other options)]"
function flake-rebuild-remote
    # exit with error message if hostname wasnt given as first arg
    if test "x$argv[1]" = "x"
        set_color red
        echo -n "error: "
        set_color normal
        echo "no hostname given!"
        return 1
    end

    # use --impure if NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT is set
    if test "$NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT" = "1"
        set impure "--impure"
    end

    # rebuild with hostname, --impure (if set), other given args and nom (for prettier output)
    nixos-rebuild switch --fast --use-remote-sudo \
        --flake /etc/dotfiles\#$argv[1] \
        --target-host $argv[1] \
         --build-host $argv[1] \
        $impure $argv[2..-1] \
        &| nom
    return $status
end