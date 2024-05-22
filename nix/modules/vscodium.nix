# vscodium with extensions (text editor)
args@{ pkgs, variables, vscode-extensions, ... }:
{
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
        bbenoist.nix
        dlasagno.rasi
        eww-yuck.yuck
        ms-python.python 
        mshr-h.veriloghdl
        ms-vscode.cpptools
        bmalehorn.vscode-fish
        mesonbuild.mesonbuild
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        coolbear.systemd-unit-file
        ms-azuretools.vscode-docker
        matthewpi.caddyfile-support
        # other stuff
        vscodevim.vim # vim :)
        eamodio.gitlens # advanced git integration
        ritwickdey.liveserver # quick webserver for testing
        esbenp.prettier-vscode # code formatter
        naumovs.color-highlight # highlight color codes with their color
        ms-python.vscode-pylance # more python (PROPRIETARY)
        leetcode.vscode-leetcode # solve leetcode problems
        pkief.material-icon-theme # file icon theme
        christian-kohler.path-intellisense # auto complete paths
      ];
    })
  ];
}