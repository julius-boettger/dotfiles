# most basic config for all devices
args@{ pkgs, variables, ... }:
{
  # self-explaining one-liners
  console.keyMap = "de";
  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = variables.version;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = args.device.hostName;
    networkmanager.enable = true;
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

  ##########################################
  ##########################################
  ################ PACKAGES ################
  ##########################################
  ##########################################

  environment.systemPackages = with pkgs; [
    vim
    bash
    jq # process json
    lsd # better ls
    bat # better cat
    fzf # fast fuzzy finder
    zoxide # better cd
    unstable.numbat # cli calculator
    fastfetch # neofetch but fast
    starship # shell prompt, install as program and package to set PATH
    fortune # random quote
    nix-output-monitor # prettier output of nix commands
    unstable.nh # nix helper (prettier/better nix commands)
    # compilers, interpreters, debuggers
    (python3.withPackages (python-pkgs: with python-pkgs; [
      virtualenv
    ]))
  ];

  ###########################################
  ###########################################
  ########### PROGRAMS / SERVICES ###########
  ###########################################
  ###########################################

  # for secret storing stuff
  services.gnome.gnome-keyring.enable = true;

  # for git authentication with ssh keys
  programs.ssh = {
    startAgent = true;
    # in order of preference
    hostKeyAlgorithms      = [ "ssh-ed25519" "ssh-rsa" ];
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" "ssh-rsa" ];
  };

  # some environment variables
  environment.variables = {
    # current device to use for flake-rebuild
    NIX_FLAKE_CURRENT_DEVICE = args.device.internalName;
    # use --impure for flake-rebuild by default (if configured)
    NIX_FLAKE_ALLOW_IMPURE_BY_DEFAULT = args.lib.mkIf variables.allowImpureByDefault "1";
  };

  ### fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  environment.variables = {
    fish_color_param = "normal";
    fish_color_error = "yellow";
    fish_color_option = "cyan";
    fish_color_command = "green";
    fish_color_autosuggestion = "brblack";
  };
  # config file location for starship prompt
  environment.variables.STARSHIP_CONFIG = "/etc/dotfiles/other/starship.toml";

  ############################################
  ############################################
  ############### HOME-MANAGER ###############
  ############################################
  ############################################
  # manage stuff in /home/$USER/
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${variables.username} = { config, ... }: {

  home.stateVersion = variables.version;
  # i dont know what this does?
  programs.home-manager.enable = true;

  # symlink fish config to ~/.config/fish/config.fish
  xdg.configFile."fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/init.fish";

  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = "main";
    userName = variables.git.name;
    userEmail = variables.git.email;
  };
};}