{ writeShellScriptBin, firefoxProfile }: writeShellScriptBin "symlink-dotfiles" ''

ln -sf /etc/nixos/.ideavimrc $HOME
ln -sf /etc/nixos/awesome    $HOME/.config
ln -sf /etc/nixos/ulauncher  $HOME/.config
ln -sf /etc/nixos/picom.conf $HOME/.config

# autokey phrases
mkdir -p $HOME/.config/autokey/phrases
ln -sf /etc/nixos/autokey-phrases/* $HOME/.config/autokey/phrases/

# firefox theme
mkdir -p $HOME/.mozilla/firefox/${firefoxProfile}/chrome
ln -sf /etc/nixos/firefox.css $HOME/.mozilla/firefox/${firefoxProfile}/chrome/userChrome.css

''