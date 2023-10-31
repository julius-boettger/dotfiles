### config variables that are shared by all of my devices
# take pkgs.callPackage as function argument
callPackage: rec {
  # import device specific or personal stuff
  secrets = import ./secrets.nix;
  # nixos state and home-manager version
  version = "23.05";
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # my own packages
  pkgs = {
    gitnuro          = callPackage ./pkgs/gitnuro.nix          {};
    hyprsome         = callPackage ./pkgs/hyprsome.nix         {};
    circadian        = callPackage ./pkgs/circadian.nix        {};
    sddm-sugar-candy = callPackage ./pkgs/sddm-sugar-candy.nix {};
    symlink-dotfiles = callPackage ./pkgs/symlink-dotfiles.nix {
      inherit username;
      firefoxProfile = secrets.firefox.profile;
    };
  };
}