-- plugin for workspaces per monitor (no local to have hyprctl dispatch recognize it)
hs = require("hyprsplit")

---- environment variables
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- bigger cursor
hl.env("XCURSOR_SIZE", 32)
-- wallpaper animation settings
hl.env("AWWW_TRANSITION", "wipe")
hl.env("AWWW_TRANSITION_FPS", 144)
hl.env("AWWW_TRANSITION_STEP", 255)
hl.env("AWWW_TRANSITION_ANGLE", 45)

---- start background processes
-- set wallpaper and border color with awww
local wallpaper_cmd = "python /etc/dotfiles/modules/hyprland/wallpaper.py"
hl.on("hyprland.start", function()
    -- autostart
    hl.exec_cmd("/etc/dotfiles/misc/autostart.sh")
    -- open desktop widget on all monitors
    hl.exec_cmd("sleep 0.75 && eww-open-everywhere")
    -- notifications with swaync
    hl.exec_cmd("swaync")
    hl.exec_cmd("/etc/dotfiles/modules/swaync/inhibit-on-screenshare.sh")
    -- for wallpapers
    hl.exec_cmd("awww-daemon --no-cache && awww clear 000000")
    hl.exec_cmd("sleep 0.1 && " .. wallpaper_cmd)
end)

---- window rules
-- https://wiki.hyprland.org/Configuring/Window-Rules/
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, float = true })
-- opacity
hl.window_rule({ match = { class = "codium" }, opacity = 0.9 })
hl.window_rule({ match = { class = "com-jetpackduba-gitnuro-MainKt" }, opacity = 0.85 })
hl.window_rule({ match = { initial_title = "^Obsidian - Obsidian.*" }, opacity = 0.8 })
hl.window_rule({ match = { class = "org.gnome.Nautilus" },             opacity = 0.8 })
hl.window_rule({ match = { class = "gcr-prompter" },                   opacity = 0.8 })
hl.window_rule({ match = { class = "Lxpolkit" },                       opacity = 0.8 })
hl.window_rule({ match = { class = "spotify" },                        opacity = 0.8 })

-- flameshot (https://github.com/flameshot-org/flameshot/issues/2978)
-- TODO: fix, also see device-specific config
hl.window_rule({
    name  = "flameshot",
    match = {
        initial_title = "flameshot",
    },
    move = { 0, 0 },
    monitor = 0,
    rounding = 0,
    pin = true,
    float = true,
    no_anim = true,
})

---- layer rules
-- blur if not fully transparent
for _, namespace in ipairs({"rofi", "eww-desktop-widget", "swaync-control-center"}) do
    hl.layer_rule({
        match = { namespace = namespace },
        blur = true,
        ignore_alpha = 0,
    })
end
-- swaync notifications (ignorealpha for smoother notification fade-out)
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.25,
})

---- variables
-- https://wiki.hyprland.org/Configuring/Variables/
hl.config({
    general = {
        gaps_in = 2.5,
        gaps_out = 5,
        border_size = 3,
        layout = "dwindle",
        resize_on_border = true,
        extend_border_grab_area = 10,
        hover_icon_on_border = false,
        col = {
            inactive_border = "rgb(363537)",
            -- will be overridden by python script
            active_border = {
                colors = {"rgb(7BD88F)", "rgb(5AD4E6)"},
                angle = 45,
            },
        },
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            ignore_opacity = true,
            passes = 3,
            size = 9,
            -- rightclick menus
            popups = true,
            popups_ignorealpha = 0.15, -- looks best in nautilus
        },
        -- disable all shadow stuff
        shadow = {
            enabled = false,
            range = 0,
            render_power = 1,
            color = "rgba(00000000)",
            scale = 0.0,
        },
    },
    misc = {
        on_focus_under_fullscreen = 1,
        mouse_move_enables_dpms = true,
        -- black background by default
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        background_color = "rgb(000000)",
    },
    input = {
        kb_layout = "de",
        mouse_refocus = false, -- only change mouse focus when crossing borders
        follow_mouse = 1,
    },
    dwindle = {
        -- https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        -- more control over split direction based on cursor position
        smart_split = true,
    },
    binds = {
        -- focus last active window on workspace switch
        workspace_center_on = 1,
    },
    cursor = {
        inactive_timeout = 3, -- seconds
    },
    ecosystem = {
        no_update_news = true,
    },
})

---- animations
-- register curves from https://easings.net/
hl.curve("easeInQuart",    { type = "bezier", points = { {0.50, 0}, {0.75, 0}}})
hl.curve("easeOutQuart",   { type = "bezier", points = { {0.25, 1}, {0.50, 1}}}) -- pretty similar to default
hl.curve("easeInOutQuart", { type = "bezier", points = { {0.76, 0}, {0.24, 1}}})
-- border color change
hl.animation({ enabled = true, leaf = "border", speed = 10, bezier = "default" })
-- border gradient angle change
hl.animation({ enabled = true, leaf = "borderangle", speed = 10, bezier = "default" })
-- switch workspace
hl.animation({ enabled = true, leaf = "workspaces", speed = 3, bezier = "easeInOutQuart", style = "fade" })
-- window open
hl.animation({ enabled = true, leaf = "windowsIn", speed = 5, bezier = "easeOutQuart", style = "popin 75%" })
-- window close
hl.animation({ enabled = true, leaf = "windowsOut", speed = 5, bezier = "easeOutQuart", style = "popin 90%" })
-- automatic window move/resize/... (style doesnt matter?)
hl.animation({ enabled = true, leaf = "windowsMove", speed = 3.5, bezier = "easeOutQuart" })
-- default for fade animations
hl.animation({ enabled = true, leaf = "fade", speed = 3.5, bezier = "easeOutQuart" })

---- plugin config
hs.config({
    num_workspaces = 10,
    -- only output workspaces with hyprland-workspaces if they
    -- are active or have windows on them, not all the time
    persistent_workspaces = false,
})

---- keybinds
-- https://wiki.hyprland.org/Configuring/Binds/
local mod = "SUPER"

-- submap to ignore all kinds of input
-- TODO: test if this works, adjust dispatches of it
hl.define_submap("inhibit-input", function()
    hl.bind("catchall", function() end, { ignore_mods = true })
end)

-- run programs
hl.bind(mod .. " + return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus -w"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("zen"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("codium"))
hl.bind(mod .. " + G", hl.dsp.exec_cmd("gitnuro"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd("obsidian"))

-- DE-like stuff (application launcher, screenshot, notification center, ...)
hl.bind(mod .. " + Super_L", hl.dsp.exec_cmd("pgrep rofi && pkill rofi || rofi -show drun -show-icons"), { release = true })
hl.bind(mod .. " + period", hl.dsp.exec_cmd("rofi -modi emoji:rofimoji -show emoji"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("copyq toggle"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(wallpaper_cmd))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mod .. " + CTRL + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("eww-open-everywhere && pkill awww && awww-daemon"))
hl.bind(mod .. " + CTRL + return", hs.dsp.grab_rogue_windows())

-- elevate eww desktop widget
hl.bind(mod .. " + tab", hl.dsp.exec_cmd("eww-open-everywhere true"))
hl.bind(mod .. " + tab", hl.dsp.exec_cmd("eww-open-everywhere false"), { release = true })
hl.bind(mod .. " + CTRL + tab", hl.dsp.exec_cmd("eww-open-everywhere toggle"))

-- zoom / magnifying glasses (holdable)
-- increase/decrease magnification by percentage of current value
local function zoom(increase)
    local current = hl.get_config("cursor.zoom_factor")
    local factor = 1.1 -- +10%
    local new
    if increase then
        new = current * factor
    else
        new = current * (1/factor)
        if new < 1 then new = 1 end
    end
    hl.config({ cursor = { zoom_factor = new }})
end
hl.bind(mod .. " + plus", function() zoom(true) end, { repeating = true })
hl.bind(mod .. " + minus", function() zoom(false) end, { repeating = true })

-- media player control
hl.bind("pause", hl.dsp.exec_cmd("playerctl play-pause"))

-- adjust volume (holdable)
hl.bind(mod .. " + up", hl.dsp.exec_cmd("swayosd-client --output-volume +5 && aplay /etc/dotfiles/misc/notification.wav"), { repeating = true })
hl.bind(mod .. " + down", hl.dsp.exec_cmd("swayosd-client --output-volume -5 && aplay /etc/dotfiles/misc/notification.wav"), { repeating = true })
hl.bind(mod .. " + CTRL + M", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- power state stuff
hl.bind(mod .. " + CTRL + SHIFT + L", hl.dsp.exit())
hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

-- show OSD when pressing caps lock
hl.bind("Caps_Lock", hl.dsp.exec_cmd("sleep 0.1 && swayosd-client --caps-lock"), { non_consuming = true, ignore_mods = true })

-- adjust brightness (holdable)
hl.bind(mod .. " + CTRL + up", hl.dsp.exec_cmd("swayosd-client --brightness +5"), { locked = true, repeating = true })
hl.bind(mod .. " + CTRL + down", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { locked = true, repeating = true })

-- just Hyprland stuff
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + space", hl.dsp.window.float())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + M", hl.dsp.window.fullscreen())

-- maximize on mouse wheel press
hl.bind(mod .. " + mouse:274", hl.dsp.window.fullscreen())
-- move/resize windows with mouse buttons while holding $mod
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---- cycle focus
-- on same monitor
hl.bind(mod .. " + j", hl.dsp.window.cycle_next())
hl.bind(mod .. " + k", hl.dsp.window.cycle_next({ next = false }))

-- on all monitors (needs different dispatcher or args)
--hl.bind(mod .. " + SHIFT + j", hl.dsp.window.cycle_next())
--hl.bind(mod .. " + SHIFT + k", hl.dsp.window.cycle_next({ next = false }))

------- unique workspace per monitor with hyprsplit
-- per-monitor, from 1 to 9, for hyprsplit
local function next_cyclic_workspace(increase)
    local current = hl.get_active_workspace().id
    local new = current % 10
    if increase then new = new + 1 else new = new - 1 end
    if new < 1 then new = 9 end
    if new > 9 then new = 1 end
    return new
end

---- switch workspace
-- next/previous
hl.bind(mod .. " + h", function() hl.dispatch(hs.dsp.focus({ workspace = next_cyclic_workspace(false) })) end)
hl.bind(mod .. " + l", function() hl.dispatch(hs.dsp.focus({ workspace = next_cyclic_workspace(true ) })) end)
-- number
for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hs.dsp.focus({ workspace = i }))
end

---- move window to workspace
-- next/previous
hl.bind(mod .. " + SHIFT + h", function() hl.dispatch(hs.dsp.window.move({ workspace = next_cyclic_workspace(false), follow = false })) end)
hl.bind(mod .. " + SHIFT + l", function() hl.dispatch(hs.dsp.window.move({ workspace = next_cyclic_workspace(true ), follow = false })) end)
-- number
for i = 1, 9 do
    hl.bind(mod .. " + SHIFT + " .. i, hs.dsp.window.move({ workspace = i, follow = false }))
end
