# build local packages (in this directory)
{ pkgs, ... }:
builtins.readDir ./.
|> builtins.attrNames
|> builtins.filter (name: name != "default.nix") # ignore this file
|> map (name: {
  name = pkgs.lib.strings.removeSuffix ".nix" name;
  value = pkgs.callPackage ./${name} {};
})
|> builtins.listToAttrs
