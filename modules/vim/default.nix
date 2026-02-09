# terminal text editor
args@{ config, lib, pkgs, ... }:
lib.mkModule "vim" config {
  environment.systemPackages = [ pkgs.vim ];

  # symlink config to ~
  home-manager.users.${config.username} = { config, sysconfig, ... }: {
    home.file.".vimrc".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/dotfiles/modules/vim/.vimrc";
  };
}