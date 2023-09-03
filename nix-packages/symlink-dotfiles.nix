{ writeShellScriptBin, firefoxProfile }: writeShellScriptBin "symlink-dotfiles" ''

ln -s /etc/nixos/.ideavimrc $HOME
ln -s /etc/nixos/awesome    $HOME/.config
ln -s /etc/nixos/picom.conf $HOME/.config

# autokey phrases
mkdir -p $HOME/.config/autokey/phrases
ln -s /etc/nixos/autokey-phrases/* $HOME/.config/autokey/phrases/

# ulauncher theme
mkdir -p $HOME/.config/ulauncher/user-themes/mytheme
ln -s /etc/nixos/ulauncher-theme/* $HOME/.config/ulauncher/user-themes/mytheme/

# firefox theme
mkdir -p $HOME/.mozilla/firefox/${firefoxProfile}/chrome
ln -s /etc/nixos/firefox.css $HOME/.mozilla/firefox/${firefoxProfile}/chrome/userChrome.css

''