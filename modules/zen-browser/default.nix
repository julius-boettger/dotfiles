# internet browser
args@{ config, lib, inputs, ... }:
lib.mkModule "zen-browser" config {
  environment.systemPackages = [
    (lib.getPkgs "zen-browser").default
  ];
}