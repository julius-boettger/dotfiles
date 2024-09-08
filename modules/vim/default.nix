# terminal text editor
args@{ config, lib, pkgs, variables, ... }:
lib.mkModule "vim" config {
  environment.systemPackages = [ pkgs.vim ];

  # symlink config to ~
  home-manager.users.${variables.username} = { config, ... }: {
    home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink ./.vimrc;
  };
}