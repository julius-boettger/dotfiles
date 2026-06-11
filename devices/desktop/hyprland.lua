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

---- key binds
-- mount encrypted data partition
hl.bind("SUPER + CTRL + SHIFT + M", hl.dsp.exec_cmd("/etc/dotfiles/devices/desktop/mount-data.sh"))
-- next song
hl.bind("print", hl.dsp.exec_cmd("playerctl next"))
-- toggle power state of all monitors 
hl.bind("SUPER + CTRL + SHIFT + P", function()
    local monitors_on = hl.get_active_monitor().dpms_status
    if monitors_on then
        -- turn off
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
        hl.dispatch(hl.dsp.exec_cmd("openrgb -p off"))
    else
        -- turn on
        hl.dispatch(hl.dsp.dpms({ action = "enable" }))
        hl.dispatch(hl.dsp.exec_cmd("openrgb -p default"))
    end
end)

---- window rules
-- for steam games
for _, match in ipairs({{ xdg_tag = "proton-game" }, { initial_class = "steam_app_.*" }}) do
    hl.window_rule({
        match = match,
        monitor = 1,
        fullscreen = true,
        immediate = true,
    })
end

-- fix flameshot
hl.window_rule({
    match = {
        initial_title = "flameshot",
    },
    size = {4480, 1440},
})

-- nvidia gpu config
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- input settings
hl.config({
    input = {
        sensitivity = -0.7,
    },
})
