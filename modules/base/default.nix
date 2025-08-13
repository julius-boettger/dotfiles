args@{ lib, pkgs, variables, device, ... }:
{
  # other base modules can be enabled if desired
  imports = [
    ./gui
    ./gui/full.nix
    ./laptop.nix
  ];

  #########################################################
  ### most basic configuration every device should have ###
  #########################################################

  # self-explaining one-liners
  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = variables.version;
  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 0; # only show when pressing keys during boot
    grub.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 20; # number of generations to show
    };
  };

  console = {
    earlySetup = true;
    keyMap = "de";
    colors = [
      "000000" "FC618D" "7BD88F" "FD9353" "5AA0E6" "948AE3" "5AD4E6" "F7F1FF"
      "99979B" "FB376F" "4ECA69" "FD721C" "2180DE" "7C6FDC" "37CBE1" "FFFFFF"
    ];
  };

  networking = {
    hostName = device.hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  i18n.defaultLocale  = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
  };

  # database for command-not-found in a declarative way without channels
  # https://blog.nobbz.dev/2023-02-27-nixos-flakes-command-not-found/
  environment.etc."programs.sqlite".source =
    (lib.getPkgs "programs-sqlite").programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  ### user account and groups
  # create new group with username
  users.groups.${variables.username} = {};
  # create user
  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.username;
    extraGroups = [ # add user to groups (if they exist)
      variables.username
      "users"
      "wheel"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    bash
    jq # process json
    lsd # better ls
    bat # better cat
    fzf # fast fuzzy finder
    tldr # summarize man pages
    zoxide # better cd
    nomino # file renaming
    hyperfine # benchmarking tool
    numbat # cli calculator
    fortune # random quote
    librespeed-cli # speedtest
    nix-output-monitor # prettier output of nix commands
    cbonsai # ascii art bonsai
    asciiquarium-transparent # ascii art aquarium
  ];

  local = {
    vim.enable = true;
    fish.enable = true;
    sops.enable = true;
    starship.enable = true;
    fastfetch.enable = true;
    devtools.python.enable = true;
    distributed-builds.enable = true;
  };

  # load dev environment from directory
  programs.direnv.enable = true;

  # run dynamically-linked binaries not meant for NixOS
  programs.nix-ld.enable = true;

  # ensure /bin/bash exists to make
  # #!/bin/bash script shebangs working
  system.activationScripts.binbash.text =
    "ln -sf /run/current-system/sw/bin/bash /bin/bash";

  # nix helper (prettier/better nix commands)
  programs.nh =  {
    enable = true;
    package = (lib.getPkgs "nh").nh;
    # automatic nix garbage collect
    clean = {
      enable = true;
      dates = lib.mkDefault "monthly";
      # always keep 2 generations
      extraArgs = "--keep 2";
    };
  };

  # more nix cache
  nix.settings = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  # disable hibernation
  systemd.sleep.extraConfig = ''
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # for git authentication with ssh keys
  programs.ssh = {
    startAgent = true;
    # in order of preference
    hostKeyAlgorithms      = [ "ssh-ed25519" "ssh-rsa" ];
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" "ssh-rsa" ];
  };

  # some environment variables
  environment.variables = {
    EDITOR = "vim";
    # colorize man pages with bat
    MANPAGER = "sh -c 'col -bx | bat --language man --plain'";
    MANROFFOPT = "-c";
    # current device to use for flake-rebuild
    NIX_FLAKE_CURRENT_DEVICE = device.internalName;
    # use --impure for flake-rebuild by default (if configured)
    NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT = lib.mkIf variables.allowImpureByDefault 1;
  };

  ### manage stuff in /home/$USER/
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.${variables.username} = { config, ... }:
  {
    home.stateVersion = variables.version;

    # i dont know what this does?
    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      userName = variables.git.name;
      userEmail = variables.git.email;
      extraConfig = {
        init.defaultBranch = "main";
        fetch.prune = true; # remove deleted remote branches locally
        pull.rebase = true; # rebase merge
      };
    };
  };
}