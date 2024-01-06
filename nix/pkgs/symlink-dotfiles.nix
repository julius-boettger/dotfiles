{ writeShellScriptBin, firefoxProfile, username }: writeShellScriptBin "symlink-dotfiles" ''

ln -sf /etc/dotfiles/.ideavimrc /home/${username}
ln -sf /etc/dotfiles/awesome    /home/${username}/.config
ln -sf /etc/dotfiles/picom.conf /home/${username}/.config
ln -sf /etc/dotfiles/swaync     /home/${username}/.config
ln -sf /etc/dotfiles/eww        /home/${username}/.config

# fastfetch
mkdir -p /home/${username}/.config/fastfetch
ln -sf /etc/dotfiles/fastfetch/default.jsonc /home/${username}/.config/fastfetch/config.jsonc

# hyprland
mkdir -p /home/${username}/.config/hypr
ln -sf /etc/dotfiles/hyprland/hyprland.conf /home/${username}/.config/hypr

# copyq
mkdir -p /home/${username}/.config/copyq
ln -sf /etc/dotfiles/copyq.conf /home/${username}/.config/copyq

# rofi
mkdir -p /home/${username}/.local/share/rofi/themes
ln -sf /etc/dotfiles/rofi.rasi /home/${username}/.local/share/rofi/themes

# firefox theme
mkdir -p /home/${username}/.mozilla/firefox/${firefoxProfile}/chrome
ln -sf /etc/dotfiles/firefox.css /home/${username}/.mozilla/firefox/${firefoxProfile}/chrome/userChrome.css
echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' > /home/${username}/.mozilla/firefox/${firefoxProfile}/user.js

''