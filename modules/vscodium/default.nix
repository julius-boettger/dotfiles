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
        # for syntax highlighting / language support
        dlasagno.rasi
        eww-yuck.yuck
        jnoortheen.nix-ide
        bmalehorn.vscode-fish
        mesonbuild.mesonbuild
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        nixpkgs-exts.ms-vscode.cpptools # https://github.com/nix-community/nix-vscode-extensions/issues/69
        # other stuff
        mkhl.direnv # load dev environment from directory
        vscodevim.vim # vim :)
        eamodio.gitlens # advanced git integration
        esbenp.prettier-vscode # code formatter
        naumovs.color-highlight # highlight color codes with their color
        pkief.material-icon-theme # file icon theme
        monokai.theme-monokai-pro-vscode # color theme
        christian-kohler.path-intellisense # auto complete paths
      ];
    })
  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/vscodium/vscodium.json";
  };
}