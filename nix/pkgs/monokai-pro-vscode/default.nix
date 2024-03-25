# monokai pro color theme vscode extension
# with custom postInstall python script
# https://github.com/NixOS/nixpkgs/blob/e5005453d3315aa58a04b901cbecbef5e241f7b1/pkgs/applications/editors/vscode/extensions/vscode-utils.nix 
{ vscode-utils, python3 }:
let 
  mktplcRef = {
    publisher = "monokai";
    name = "theme-monokai-pro-vscode";
    version = "1.2.2";
    sha256 = "xeLzzNgj/GmNnSmrwSfJW6i93++HO3MPAj8RwZzwzR4=";
  };
in
vscode-utils.buildVscodeExtension
{
  # required attributes
  src = vscode-utils.fetchVsixFromVscodeMarketplace mktplcRef;
  name = "${mktplcRef.publisher}-${mktplcRef.name}-${mktplcRef.version}";
  version = mktplcRef.version;
  vscodeExtName = mktplcRef.name;
  vscodeExtPublisher = mktplcRef.publisher;
  vscodeExtUniqueId = "${mktplcRef.publisher}.${mktplcRef.name}";

  # call python script with path to extension source
  postInstall = ''${python3}/bin/python3 ${./post_install.py} "$out/$installPrefix"'';
}