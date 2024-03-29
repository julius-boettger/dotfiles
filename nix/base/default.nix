# this file contains basic config i want to have on every device
{ pkgs, host, variables, ... }:
{
  # self-explaining one-liners
  console.keyMap = "de";
  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = variables.version;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = host.name;
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

  # packages to install, mostly command line stuff
  environment.systemPackages = with pkgs; [
    vim
    bash
    jq # process json
    lsd # better ls
    bat # better cat
    fzf # fast fuzzy finder
    tldr # summarize man pages
    zoxide # better cd
    fastfetch # neofetch but fast
    librespeed-cli # speedtest
    meson ninja # for building c/c++ projects
    pkg-config # for c/c++/rust dependency management
    cbonsai # ascii art bonsai
    asciiquarium # ascii art aquarium
    starship # shell prompt, install as program and package to set PATH
    fortune # random quote
    # compilers, interpreters, debuggers
    gcc
    jdk
    rustup
    nodePackages_latest.nodejs
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

  # fix pkg-config by pointing it in the right way
  environment.sessionVariables.PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";

  # for git authentication with ssh keys
  programs.ssh = {
    startAgent = true;
    # in order of preference
    hostKeyAlgorithms      = [ "ssh-ed25519" "ssh-rsa" ];
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" "ssh-rsa" ];
  };

  ### fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  environment.sessionVariables = {
    fish_color_param = "normal";
    fish_color_error = "yellow";
    fish_color_option = "cyan";
    fish_color_command = "green";
    fish_color_autosuggestion = "brblack";
  };
  # config file location for starship prompt
  environment.sessionVariables.STARSHIP_CONFIG = "/etc/dotfiles/other/starship.toml";

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