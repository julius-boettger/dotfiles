---@module 'hl'
-- TODO: is the above necessary?

-- TODO: can this be combined into one?
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@144",
    position = "1920x0",
    scale    = 1,
})

------- key binds
-- TODO: can these strings be merged?
-- mount encrypted data partition
hl.bind("SUPER + CTRL + SHIFT" .. " + " .. "M", hl.dsp.exec_cmd("/etc/dotfiles/devices/desktop/mount-data.sh"))
-- toggle power state of all monitors 
hl.bind("SUPER + CTRL + SHIFT" .. " + " .. "P", hl.dsp.exec_cmd("hyprctl monitors -j| jq -e '.[0].dpmsStatus' && { hyprctl dispatch dpms off; openrgb -p off; } || { hyprctl dispatch dpms on; openrgb -p default; }"))
-- next song
hl.bind("print", hl.dsp.exec_cmd("playerctl next"))

------- window rules

-- for steam games
hl.window_rule({
    name  = "steam-games",
    -- TODO: can something like this be flattened?
    match = {
        xdg_tag = "proton-game",
    },
    monitor = 1,
    fullscreen = true,
    immediate = true,
})

-- fix flameshot
hl.window_rule({
    name  = "match_initial_title_",
    match = {
        class = "size 4480 1440",
    },
    -- TODO: review rule: "match:initial_title flameshot"
})

------- nvidia gpu config
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

------- input settings
hl.config({
    input = {
        sensitivity = -0.7,
    },
})
