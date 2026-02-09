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
    # setup direnv to load dev environment from directory
    direnv hook fish | source

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
    bind -M insert -m default ctrl-c repaint-mode
    # ctrl+backspace => delete input line
    bind -M insert ctrl-backspace backward-kill-line
    # ctrl+space => go through options
    bind -M insert ctrl-space complete
    # tab => accept suggestion
    bind -M insert tab accept-autosuggestion

    ### aliases
    alias cd z
    alias ls lsd
    alias cat bat

    ### functions
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

### global aliases
alias aquarium "asciiquarium --transparent"
alias flake-update "/etc/dotfiles/misc/update.sh"
alias flake-pull "git -C /etc/dotfiles pull --rebase --autostash"

### global functions

# test command for maximum memory usage and runtime
function memtime
    if test -z "$argv"
        set_color red
        echo -n "Error: "
        set_color normal
        echo "no command given!"
        return 1
    end
    set_color --bold
    echo -n "Maximum memory usage"
    set_color normal
    echo -n " (RSS): "
    set_color green --bold
    command time -v $argv > /dev/null 2>| \
        grep "Maximum resident set size" | \
        awk '{print $6 "K"}' | \
        numfmt --from si --to si
    set_color normal
    hyperfine --shell none "$argv"
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

    # allow overriding `nh os` command used below with env var
    if test "x$NIX_FLAKE_NH_OS_COMMAND" = "x"
        set NIX_FLAKE_NH_OS_COMMAND "switch"
    end

    # rebuild with nh (for prettier output), current device,
    # --impure (if set) and other given args
    nh os $NIX_FLAKE_NH_OS_COMMAND -H $NIX_FLAKE_CURRENT_DEVICE -d always /etc/dotfiles -- $impure $argv
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
    nixos-rebuild switch --sudo --no-reexec \
        --flake /etc/dotfiles\#$argv[1] \
        --target-host $argv[1] \
         --build-host $argv[1] \
        $impure $argv[2..-1] \
        &| nom
    return $status
end

# run flake-rebuild (build), suspend, run flake-rebuild (switch)
function flake-rebuild-suspend
    NIX_FLAKE_NH_OS_COMMAND=build flake-rebuild $argv
    systemctl suspend
    flake-rebuild $argv
    return $status
end
