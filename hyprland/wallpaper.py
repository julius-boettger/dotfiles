import random, subprocess, time

colors = {
    # color format for hyprland
    "r": "rgb(FC618D)",
    "g": "rgb(7BD88F)",
    "y": "rgb(FD9353)",
    "b": "rgb(5AA0E6)",
    "m": "rgb(948AE3)",
    "c": "rgb(5AD4E6)"
}

WALLPAPER_FORMAT = "/etc/dotfiles/wallpapers/nixos/{}.png"
wallpapers = [
    "rg", "gr",
    "ry", "yr",
    "rb", "br",
    "rm", "mr",
    "rc", "cr",
    "gy", "yg",
    "gb", "bg",
    "gm", "mg",
    "gc", "cg",
    "yb", "by",
    "ym", "my",
    "yc", "cy",
    "bm", "mb",
    "bc", "cb",
    "mc", "cm",
]

# choose random wallpaper and save path to it
wallpaper = random.choice(wallpapers)
wallpaper_path = WALLPAPER_FORMAT.format(wallpaper)

# get all 4 colors not in the wallpaper in random order
available_color_keys = list(set(colors.keys()) - set(wallpaper))
random.shuffle(available_color_keys)
available_colors = [colors[c] for c in available_color_keys]
color1 = available_colors[0]
color2 = available_colors[1]
color3 = available_colors[2]
color4 = available_colors[3]

# set wallpaper
subprocess.run(["swww", "img", wallpaper_path])
# wait a bit
time.sleep(2)
# set border color to gradient between color1 and color2
subprocess.run(["hyprctl", "keyword", "general:col.active_border", color1, color2, "45deg"])