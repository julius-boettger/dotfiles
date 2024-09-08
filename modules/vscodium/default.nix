# vscodium with extensions (text editor)
args@{ config, lib, pkgs, inputs, variables, device, ... }:
let
  # extensions from extra flake
  exts = (import inputs.nix-vscode-extensions).extensions.${device.system};
  # extensions directly from nixpkgs
  nixpkgs-exts = pkgs.unstable.vscode-extensions;
in
lib.mkModule "vscodium" config {
  environment.systemPackages = [
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.unstable.vscodium;
      vscodeExtensions =
        with exts.vscode-marketplace;
       #with exts.open-vsx; # seems to cause issues...?
        with exts.vscode-marketplace-release;
        with exts.open-vsx-release; # <-- use first if available, otherwise go up
      [
        # monokai pro color theme from local package
        pkgs.local.monokai-pro-vscode
        # for syntax highlighting / language support
        dlasagno.rasi
        eww-yuck.yuck
        csstools.postcss
        jnoortheen.nix-ide
        svelte.svelte-vscode
        bmalehorn.vscode-fish
        mesonbuild.mesonbuild
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        bradlc.vscode-tailwindcss
        coolbear.systemd-unit-file
        ms-azuretools.vscode-docker
        matthewpi.caddyfile-support
        nixpkgs-exts.ms-vscode.cpptools # https://github.com/nix-community/nix-vscode-extensions/issues/69
        # other stuff
        vscodevim.vim # vim :)
        eamodio.gitlens # advanced git integration
        ritwickdey.liveserver # quick webserver for testing
        esbenp.prettier-vscode # code formatter
        naumovs.color-highlight # highlight color codes with their color
        leetcode.vscode-leetcode # solve leetcode problems
        pkief.material-icon-theme # file icon theme
        christian-kohler.path-intellisense # auto complete paths
      ];
    })
  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/vscodium/vscodium.json";
  };
}