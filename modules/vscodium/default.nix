# vscodium with extensions (text editor)
args@{ pkgs, lib, config, variables, vscode-extensions, ... }:
let
  # extensions directly from nixpkgs
  nixpkgs-ext = pkgs.unstable.vscode-extensions;
in
{
  options.local.vscodium.enable = lib.mkEnableOption "whether to enable vscodium";
  config = lib.mkIf config.local.vscodium.enable {
    environment.systemPackages = [
      (pkgs.vscode-with-extensions.override {
        vscode = pkgs.unstable.vscodium;
        vscodeExtensions =
          with vscode-extensions.vscode-marketplace;
        #with vscode-extensions.open-vsx; # seems to cause issues...?
          with vscode-extensions.vscode-marketplace-release;
          with vscode-extensions.open-vsx-release; # <-- use first if available, otherwise go up
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
          nixpkgs-ext.ms-vscode.cpptools # https://github.com/nix-community/nix-vscode-extensions/issues/69
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
  };
}