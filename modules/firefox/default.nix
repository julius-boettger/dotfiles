# browser
args@{ config, lib, variables, ... }:
lib.mkModule "firefox" config {
  home-manager.users.${variables.username} = { config, ... }: {
    programs.firefox = {
      enable = true;
      # allow custom css
      profiles.default.settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    
    # symlink custom css to ~
    home.file.".mozilla/firefox/default/chrome/userChrome.css".source = config.lib.file.mkOutOfStoreSymlink ./firefox.css;
  };
}