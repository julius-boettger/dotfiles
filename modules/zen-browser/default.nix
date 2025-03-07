# internet browser
args@{ config, lib, inputs, variables, ... }:
lib.mkModule "zen-browser" config {
  home-manager.users.${variables.username} = { config, ... }: {
    imports = [ inputs.zenix.hmModules.default ];

    programs.zenix = {
      enable = true;

      chrome = {
        findbar = true; # better-looking ctrl-f bar
        hideTitlebarButtons = true;
      };

      profiles.default = {
        isDefault = true;
        # necessary for some reason?
        id = 0;
        settings = {};
      };
    };
  };
}