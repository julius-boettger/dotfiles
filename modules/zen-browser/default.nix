# internet browser
args@{ config, lib, pkgs, inputs, variables, ... }:
let
  extensions = pkgs.nur.repos.rycee.firefox-addons;
in
lib.mkModule "zen-browser" config {
  home-manager.users.${variables.username} = { config, ... }: {
    imports = [ inputs.zenix.homeModules.default ];

    programs.zenix = {
      enable = true;

      chrome = {
        findbar = true; # better-looking ctrl-f bar
        hideTitlebarButtons = true;
      };

      profiles.default = {
        isDefault = true;

        userChrome.source = config.lib.file.mkOutOfStoreSymlink
          "/etc/dotfiles/modules/zen-browser/userChrome.css";

        extensions.packages = with extensions; [
          bitwarden
          qwant-search
          languagetool
          tampermonkey
          ublock-origin
          decentraleyes
          privacy-badger
          return-youtube-dislikes
          istilldontcareaboutcookies
        ];

        extraConfig = ''
          user_pref("layout.spellcheckDefault", 0);
          user_pref("zen.tab-unloader.enabled", false);
          user_pref("zen.view.sidebar-expanded", false);
          user_pref("zen.view.use-single-toolbar", false);
          user_pref("zen.glance.activation-method", "shift");
          user_pref("signon.rememberSignons", false); // ask to save passwords
          user_pref("extensions.formautofill.addresses.enabled", false);
          user_pref("extensions.formautofill.creditCards.enabled", false);
          user_pref("browser.startup.page", 1); // open previous tabs
          user_pref("browser.search.suggest.enabled", true);
          user_pref("browser.newtabpage.activity-stream.showWeather", false);
          user_pref("browser.download.always_ask_before_handling_new_types", false);
        '';
      };

      chrome.variables.colors = {
        primary = "#5AA0E6";
        secondary = "#FD9353";
        maroon = "#FC618D";
        highlight = "#5AD4E6";
        text = "#F7F1FF";
        base = "#262527";
        mantle = "#201F21";
        crust = "#1F1E20";
        #surface0 = "#363a4f";
        #surface1 = "#494d64";
        #surface2 = "#5b6078";
        #overlay0 = "#6e738d";

        #blue = "#8aadf4";
        #blueInvert = "#8aadf4";
        #bluePale = "#91d7e3";

        #purple = "#c6a0f6";
        #purpleInvert = "#c6a0f6";
        #purplePale = "#b7bdf8";

        #cyan = "#8bd5ca";
        #cyanInvert = "#8bd5ca";
        #cyanPale = "#91d7e3";

        #orange = "#f08f66";
        #orangeInvert = "#f08f66";
        #orangePale = "#f5a97f";

        #yellow = "#eed49f";
        #yellowInvert = "#eed49f";
        #yellowPale = "#eed49f";

        #pink = "#f5bde6";
        #pinkInvert = "#f5bde6";
        #pinkPale = "#f0c6c6";

        #green = "#a6da95";
        #greenInvert = "#a6da95";
        #greenPale = "#a6da95";

        #red = "#ed8796";
        #redInvert = "#ed8796";
        #redPale = "#f5bde6";

        #gray = "#939ab7";
        #grayInvert = "#939ab7";
        #grayPale = "#b8c0e0";
      };
    };
  };
}