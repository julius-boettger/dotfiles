{ writeShellScriptBin, firefoxProfile, username }: writeShellScriptBin "symlink-dotfiles" ''

ln -sf /etc/nixos/.ideavimrc /home/${username}
ln -sf /etc/nixos/awesome    /home/${username}/.config
ln -sf /etc/nixos/ulauncher  /home/${username}/.config
ln -sf /etc/nixos/picom.conf /home/${username}/.config

# autokey phrases
mkdir -p /home/${username}/.config/autokey/phrases
ln -sf /etc/nixos/autokey-phrases/* /home/${username}/.config/autokey/phrases/

# firefox theme
mkdir -p /home/${username}/.mozilla/firefox/${firefoxProfile}/chrome
ln -sf /etc/nixos/firefox.css /home/${username}/.mozilla/firefox/${firefoxProfile}/chrome/userChrome.css

''