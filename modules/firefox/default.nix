# browser
args@{ config, lib, ... }:
lib.mkModule "firefox" config {
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    programs.firefox = {
      enable = true;
      # allow custom css
      profiles.default.settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    
    # symlink custom css to ~
    home.file.".mozilla/firefox/default/chrome/userChrome.css".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/firefox/firefox.css";
  };
}