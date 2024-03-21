{ pkgs, ... }:
let
  variables = import ./variables.nix pkgs.callPackage;
in {
  console.keyMap = "de";
  time.timeZone = "Europe/Berlin";
  system.stateVersion = variables.version;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "HOSTNAME";
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
    git
    bash
    jq # process json
    lsd # better ls
    bat # better cat
    fzf # fast fuzzy finder
    tldr # summarize man pages
    zoxide # better cd
    fastfetch # neofetch but fast
    git-credential-manager
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
    nodejs_20
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
  # also explicitly fix https://github.com/sfackler/rust-openssl/issues/1663
  environment.sessionVariables.PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig";

  ### fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  environment.sessionVariables = {
    fish_color_param = "blue";
    fish_color_error = "yellow";
    fish_color_option = "cyan";
    fish_color_command = "green";
    fish_color_autosuggestion = "white";
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
  home-manager.users.julius = { config, ... }: {

  home.stateVersion = variables.version;
  # i dont know what this does?
  programs.home-manager.enable = true;

  ### create dotfiles
  # git config (mainly for credential stuff)
  home.file.".gitconfig".text = ''
    [user]
      name = ${variables.git.name}
      email = ${variables.git.email}
    [init]
      defaultBranch = main
    [credential]
      credentialStore = secretservice
      helper = ${pkgs.git-credential-manager}/bin/git-credential-manager
  '';

  ### symlink dotfiles
  # files in ~/.config/
  xdg.configFile = {
    "fish/config.fish".source       = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/other/fish-init.fish";
    "fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/fastfetch/default.jsonc";   
  };
};}