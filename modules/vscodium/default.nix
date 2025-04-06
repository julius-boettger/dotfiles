# vscodium with extensions (text editor)
args@{ config, lib, pkgs, variables, ... }:
let
  # extensions directly from nixpkgs
  nixpkgs-exts = pkgs.unstable.vscode-extensions;
in
lib.mkModule "vscodium" config {
  environment.systemPackages = [
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.unstable.vscodium;
      vscodeExtensions =
        with pkgs.vscode-marketplace;
       #with pkgs.open-vsx; # seems to cause issues...?
        with pkgs.vscode-marketplace-release;
        with pkgs.open-vsx-release; # <-- use first if available, otherwise go up
      [
        ### for syntax highlighting / language support
        dlasagno.rasi
        eww-yuck.yuck
        jnoortheen.nix-ide
        bmalehorn.vscode-fish

        # rust
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        wgsl-analyzer.wgsl-analyzer # remember non-extension-package below!
        nixpkgs-exts.vadimcn.vscode-lldb # debugger

        # c/c++
        #ms-vscode.cpptools
        #mesonbuild.mesonbuild

        # python
        ms-python.python
        njqdev.vscode-python-typehint

        ### other stuff
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

    # for wgsl-analyzer extension
    (lib.getPkgs "wgsl-analyzer").default
  ];

  # symlink config to ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/vscodium/vscodium.json";
  };
}