# internet browser
args@{ config, lib, pkgs, inputs, variables, ... }:
let
  extensions = pkgs.nur.repos.rycee.firefox-addons;
in
lib.mkModule "zen-browser" config {
  home-manager.users.${variables.username} = { config, ... }: {
    imports = [ inputs.zenix.homeModules.default ];

    # necessary for some reason?
    programs.firefox.profiles.default = {};

    programs.zenix = {
      enable = true;

      chrome = {
        findbar = true; # better-looking ctrl-f bar
        hideTitlebarButtons = true;
      };

      profiles.default = {
        isDefault = true;
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
    };
  };
}