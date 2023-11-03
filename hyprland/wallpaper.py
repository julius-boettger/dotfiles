import random, subprocess, time, os

# color scheme to use
colors = {
    # color format for hyprland
    "r": "rgb(FC618D)",
    "g": "rgb(7BD88F)",
    "y": "rgb(FD9353)",
    "b": "rgb(5AA0E6)",
    "m": "rgb(948AE3)",
    "c": "rgb(5AD4E6)"
}

# directory of unsorted wallpapers to pick at random
OTHER_WALLPAPER_PATH = "/etc/dotfiles/wallpapers/other/"

# if directory exists and is not empty: use random wallpaper from it
if os.path.isdir(OTHER_WALLPAPER_PATH) and len(os.listdir(OTHER_WALLPAPER_PATH)) != 0:
    # interpret all files in the directory as wallpapers
    wallpapers = os.listdir(OTHER_WALLPAPER_PATH)
    # choose a random one
    wallpaper = random.choice(wallpapers)
    wallpaper_path = OTHER_WALLPAPER_PATH + wallpaper

    # set 4 accent colors in order for each wallpaper
    color_table = {
        "dawn_on_mountain_with_tree.jpg": ["b", "g", "r", "y"],
                "valley_with_beacon.jpg": ["y", "r", "g", "b"],
                  "valley_with_tree.jpg": ["g", "c", "r", "m"],
                  "dawn_on_mountain.jpg": ["y", "r", "c", "g"],
                   "purple_mountain.jpg": ["b", "g", "c", "y"],
                     "field_and_sky.jpg": ["m", "r", "g", "b"],
                     "river_and_sky.jpg": ["r", "y", "m", "g"],
                        "red_plants.jpg": ["r", "m", "g", "c"],
                         "night_sky.jpg": ["g", "m", "y", "r"],
    }

    # use colors from table if possible
    if wallpaper in color_table.keys():
        table_entry = color_table[wallpaper]
        color1 = colors[table_entry[0]]
        color2 = colors[table_entry[1]]
        color3 = colors[table_entry[2]]
        color4 = colors[table_entry[3]]
    else: # use default colors
        color1 = colors["c"]
        color2 = colors["g"]
        color3 = colors["r"]
        color4 = colors["m"]

# use random color variant of nixos wallpaper
else:
    NIXOS_WALLPAPER_FORMAT = "/etc/dotfiles/wallpapers/nixos/{}.png"
    NIXOS_WALLPAPERS = [
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

    # choose random wallpaper and format path to it
    wallpaper = random.choice(NIXOS_WALLPAPERS)
    wallpaper_path = NIXOS_WALLPAPER_FORMAT.format(wallpaper)
    # get all 4 colors not in the wallpaper in random order
    available_color_keys = list(set(colors.keys()) - set(wallpaper))
    random.shuffle(available_color_keys)
    available_colors = [colors[c] for c in available_color_keys]
    # set them as accent colors
    color1 = available_colors[0]
    color2 = available_colors[1]
    color3 = available_colors[2]
    color4 = available_colors[3]

# set wallpaper
subprocess.run(["swww", "img", wallpaper_path])
# wait a bit
time.sleep(2.5)
# set active border color to gradient between color1 and color2
subprocess.run(["hyprctl", "keyword", "general:col.active_border", color1, color2, "45deg"])