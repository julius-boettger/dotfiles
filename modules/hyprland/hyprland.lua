---@module 'hl'

------- environment variables
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- bigger cursor
hl.env("XCURSOR_SIZE", 32)
-- wallpaper animation settings
hl.env("AWWW_TRANSITION", "wipe")
hl.env("AWWW_TRANSITION_FPS", 144)
hl.env("AWWW_TRANSITION_STEP", 255)
hl.env("AWWW_TRANSITION_ANGLE", 45)

------- start background processes
-- TODO: these commands went to the autostart at the bottom, do they have to be there?
-- open desktop widget on all monitors
-- notifications with swaync
-- for wallpapers
-- set wallpaper and border color with awww
local wallpaper-cmd = "python /etc/dotfiles/modules/hyprland/wallpaper.py"

------- window rules
-- https://wiki.hyprland.org/Configuring/Window-Rules/
hl.window_rule({
    name  = "match_class_com-jetp",
    match = {
        class = "tile on",
    },
    -- TODO: review rule: "match:class com-jetpackduba-gitnuro-MainKt"
})
hl.window_rule({
    name  = "match_class_com_gith",
    match = {
        class = "float on",
    },
    -- TODO: review rule: "match:class com.github.hluk.copyq"
})
-- opacity
hl.window_rule({
    name  = "match_class_codium",
    match = {
        class = "opacity 0.9",
    },
    -- TODO: review rule: "match:class codium"
})
hl.window_rule({
    name  = "match_class_com-jetp",
    match = {
        class = "opacity 0.85",
    },
    -- TODO: review rule: "match:class com-jetpackduba-gitnuro-MainKt"
})
hl.window_rule({
    name  = "match_initial_title_",
    match = {
        class = "opacity 0.8",
    },
    -- TODO: review rule: "match:initial_title ^Obsidian- Obsidian.*"
})
hl.window_rule({
    name  = "match_class_org_gnom",
    match = {
        class = "opacity 0.8",
    },
    -- TODO: review rule: "match:class org.gnome.Nautilus"
})
hl.window_rule({
    name  = "match_class_gcr-prom",
    match = {
        class = "opacity 0.8",
    },
    -- TODO: review rule: "match:class gcr-prompter"
})
hl.window_rule({
    name  = "match_class_lxpolkit",
    match = {
        class = "opacity 0.8",
    },
    -- TODO: review rule: "match:class Lxpolkit"
})
hl.window_rule({
    name  = "match_class_spotify",
    match = {
        class = "opacity 0.8",
    },
    -- TODO: review rule: "match:class spotify"
})
-- flameshot (https://github.com/flameshot-org/flameshot/issues/2978)
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
-- TODO: all these layer rules look weird, compare with wiki examples

-- swaync notification center
hl.layer_rule({
    match = {
        namespace = "blur on",
    },
    match:namespace = "swaync-control-center",
})
hl.layer_rule({
    match = {
        namespace = "ignore_alpha 0",
    },
    match:namespace = "swaync-control-center",
})

-- swaync notifications (ignorealpha for smoother notification fade-out)
hl.layer_rule({
    match = {
        namespace = "blur on",
    },
    match:namespace = "swaync-notification-window",
})

hl.layer_rule({
    match = {
        namespace = "ignore_alpha 0.25",
    },
    match:namespace = "swaync-notification-window",
})

-- rofi
hl.layer_rule({
    match = {
        namespace = "blur on",
    },
    match:namespace = "rofi",
})
hl.layer_rule({
    match = {
        namespace = "ignore_alpha 0",
    },
    match:namespace = "rofi",
})

-- eww
hl.layer_rule({
    match = {
        namespace = "blur on",
    },
    match:namespace = "eww-desktop-widget",
})
hl.layer_rule({
    match = {
        namespace = "ignore_alpha 0",
    },
    match:namespace = "eww-desktop-widget",
})

-- TODO: merge hl.config calls?

------- variables
-- https://wiki.hyprland.org/Configuring/Variables/
hl.config({
    general = {
        gaps_in = 2.5,
        gaps_out = 5,
        border_size = 3, -- will be overridden by python script
        layout = "dwindle",
        resize_on_border = true,
        extend_border_grab_area = 10,
        hover_icon_on_border = false,
        col = {
            active_border = "rgb(363537)",
            inactive_border = "rgb(363537)",
        },
    },
})

hl.config({
    input = {
        kb_layout = "de",
        mouse_refocus = false, -- only change mouse focus when crossing borders
        follow_mouse = 1,
    },
})

hl.config({
    cursor = {
        inactive_timeout = 3, -- seconds
    },
})

hl.config({
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
            ignore_window = false,
            color = "rgba(00000000)",
            scale = 0.0,
        },
    },
})

hl.config({
    animations = {
        -- TOOD: something broke here
        -- https://wiki.hyprland.org/Configuring/Animations/
        enabled = true,
        -- curves from https://easings.net/
        -- pretty similar to default
        -- border color change
        -- border gradient angle change
        -- switch workspace
        -- switch to special workspace?
        --animation = specialWorkspace, 1, 5, easeOutQuart, slidevert
        -- default for window animations
        --animation = windows, 1, 5, easeOutQuart
        -- window open
        -- window close
        -- automatic window move/resize/... (style doesnt matter?)
        -- default for fade animations
        -- open layer/window
        --animation = fadeIn, 1, 3.5, easeOutQuart
        -- close layer/window
        --animation = fadeOut, 1, 3.5, easeOutQuart
        -- opacity change
        --animation = fadeSwitch, 1, 3.5, easeOutQuart
        -- shadow change...?
        --animation = fadeShadow, 1, 3.5, easeOutQuart
        -- inactive window dimming
        --animation = fadeDim, 1, 3.5, easeOutQuart
    },
})

hl.config({
    dwindle = {
        -- https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        -- more control over split direction based on cursor position
        smart_split = true,
    },
})

hl.config({
    binds = {
        -- focus last active window on workspace switch
        workspace_center_on = 1,
    },
})

hl.config({
    misc = {
        on_focus_under_fullscreen = 1,
        mouse_move_enables_dpms = true,
        -- black background by default
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        background_color = "rgb(000000)",
    },
})

hl.config({
    ecosystem = {
        no_update_news = true,
    },
})

------- plugins
-- TODO: is this correct?
hl.plugin("hyprsplit", function()
    num_workspaces = 10,
    -- only output workspaces with hyprland-workspaces if they
    -- are active or have windows on them, not all the time
    persistent_workspaces = false,
end)

------- keybinds
-- https://wiki.hyprland.org/Configuring/Binds/
local mod = "SUPER"
-- submap to ignore all kinds of input
hl.define_submap("inhibit-input", function()
    hl.bind("catchall", hl.dsp.exec_cmd(""), { ignore_mods = true })
end)

-- run programs
hl.bind(mod .. " + " .. "return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mod .. " + " .. "E", hl.dsp.exec_cmd("nautilus -w"))
hl.bind(mod .. " + " .. "B", hl.dsp.exec_cmd("zen"))
hl.bind(mod .. " + " .. "C", hl.dsp.exec_cmd("codium"))
hl.bind(mod .. " + " .. "G", hl.dsp.exec_cmd("gitnuro"))
hl.bind(mod .. " + " .. "O", hl.dsp.exec_cmd("obsidian"))

-- DE-like stuff (application launcher, screenshot, notification center, ...)
hl.bind(mod .. " + " .. "Super_L", hl.dsp.exec_cmd("pgrep rofi && pkill rofi || rofi -show drun -show-icons"), { repeating = true })
hl.bind(mod .. " + " .. "period", hl.dsp.exec_cmd("rofi -modi emoji:rofimoji -show emoji"))
hl.bind(mod .. " + " .. "N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + " .. "V", hl.dsp.exec_cmd("copyq toggle"))
hl.bind(mod .. " + " .. "W", hl.dsp.exec_cmd("local_var_wallpaper-cmd"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "C", hl.dsp.exec_cmd("hyprpicker| wl-copy"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "R", hl.dsp.exec_cmd("eww-open-everywhere && pkill awww && awww-daemon"))
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "return", hl.dsp.exec_cmd("hyprctl-collect-clients"))

-- elevate eww desktop widget
hl.bind(mod .. " + " .. "tab", hl.dsp.exec_cmd("eww-open-everywhere true"))
hl.bind(mod .. " + " .. "tab", hl.dsp.exec_cmd("eww-open-everywhere"), { repeating = true })
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "tab", hl.dsp.exec_cmd("eww-open-everywhere toggle"))

-- magnifying glasses around cursor (holdable)
-- increase/decrease magnification by 10% of current value (but never get below 1)
hl.bind(mod .. " + " .. "plus", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | grep float | awk '{print  local_var_2*   1.1}')"))
hl.bind(mod .. " + " .. "minus", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | grep float | awk '{print (local_var_2*(1/1.1) < 1) ? 1 : local_var_2*(1/1.1)}')"))

-- media player control
hl.bind("pause", hl.dsp.exec_cmd("playerctl play-pause"))

-- adjust volume (holdable)
hl.bind(mod .. " + " .. "up", hl.dsp.exec_cmd("swayosd-client --output-volume +5 && aplay /etc/dotfiles/misc/notification.wav"))
hl.bind(mod .. " + " .. "down", hl.dsp.exec_cmd("swayosd-client --output-volume -5 && aplay /etc/dotfiles/misc/notification.wav"))
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "M", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- power state stuff
hl.bind(mod .. " + " .. "CTRL + SHIFT" .. " + " .. "L", hl.dsp.exit())
hl.bind(mod .. " + " .. "CTRL + SHIFT" .. " + " .. "S", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

-- show OSD when pressing caps lock
hl.bind("Caps_Lock", hl.dsp.exec_cmd("sleep 0.1 && swayosd-client --caps-lock"), { non_consuming = true, ignore_mods = true })

-- adjust brightness (holdable)
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "up", hl.dsp.exec_cmd("swayosd-client --brightness +5"), { locked = true })
hl.bind(mod .. " + " .. "CTRL" .. " + " .. "down", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { locked = true })

-- just Hyprland stuff
hl.bind(mod .. " + " .. "Q", hl.dsp.window.close())
hl.bind(mod .. " + " .. "space", hl.dsp.window.float())
hl.bind(mod .. " + " .. "F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + " .. "M", hl.dsp.window.fullscreen())

-- maximize
hl.bind(mod .. " + " .. "mouse:274", hl.dsp.window.fullscreen())

-- maximize on mouse wheel press
-- scroll through workspaces on monitor while holding $mod
hl.bind(mod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "m+1" }))

-- move/resize windows with mouse buttons while holding $mod
hl.bind(mod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

---- cycle focus
-- on same monitor
hl.bind(mod .. " + " .. "j", hl.dsp.window.cycle_next())
hl.bind(mod .. " + " .. "k", hl.dsp.window.cycle_next({ next = false }))

-- on all monitors
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "j", hl.dsp.window.cycle_next())
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "k", hl.dsp.window.cycle_next())

------- unique workspace per monitor with hyprsplit
---- switch workspace
-- next/previous
hl.bind(mod .. " + " .. "h", hl.dsp.exec_cmd("hyprctl dispatch split:workspace $(/etc/dotfiles/modules/hyprland/cycle-workspace.sh -)"))
hl.bind(mod .. " + " .. "l", hl.dsp.exec_cmd("hyprctl dispatch split:workspace $(/etc/dotfiles/modules/hyprland/cycle-workspace.sh +)"))

-- number
-- TODO: manual review (unknown dispatcher: split:workspace)
-- hl.bind("$mod + 1", hl.dsp.split:workspace(1))
-- hl.bind("$mod + 2", hl.dsp.split:workspace(2))
-- hl.bind("$mod + 3", hl.dsp.split:workspace(3))
-- hl.bind("$mod + 4", hl.dsp.split:workspace(4))
-- hl.bind("$mod + 5", hl.dsp.split:workspace(5))
-- hl.bind("$mod + 6", hl.dsp.split:workspace(6))
-- hl.bind("$mod + 7", hl.dsp.split:workspace(7))
-- hl.bind("$mod + 8", hl.dsp.split:workspace(8))
-- hl.bind("$mod + 9", hl.dsp.split:workspace(9))

---- move window to workspace
-- next/previous
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "h", hl.dsp.exec_cmd("hyprctl dispatch split:movetoworkspacesilent $(/etc/dotfiles/modules/hyprland/cycle-workspace.sh -)"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "l", hl.dsp.exec_cmd("hyprctl dispatch split:movetoworkspacesilent $(/etc/dotfiles/modules/hyprland/cycle-workspace.sh +)"))
-- number
-- hl.bind("$mod + SHIFT + 1", hl.dsp.split:movetoworkspacesilent(1))
-- hl.bind("$mod + SHIFT + 2", hl.dsp.split:movetoworkspacesilent(2))
-- hl.bind("$mod + SHIFT + 3", hl.dsp.split:movetoworkspacesilent(3))
-- hl.bind("$mod + SHIFT + 4", hl.dsp.split:movetoworkspacesilent(4))
-- hl.bind("$mod + SHIFT + 5", hl.dsp.split:movetoworkspacesilent(5))
-- hl.bind("$mod + SHIFT + 6", hl.dsp.split:movetoworkspacesilent(6))
-- hl.bind("$mod + SHIFT + 7", hl.dsp.split:movetoworkspacesilent(7))
-- hl.bind("$mod + SHIFT + 8", hl.dsp.split:movetoworkspacesilent(8))
-- hl.bind("$mod + SHIFT + 9", hl.dsp.split:movetoworkspacesilent(9))

-- autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("/etc/dotfiles/misc/autostart.sh")
    hl.exec_cmd("sleep 0.75 && eww-open-everywhere")
    hl.exec_cmd("swaync")
    hl.exec_cmd("/etc/dotfiles/modules/swaync/inhibit-on-screenshare.sh")
    hl.exec_cmd("awww-daemon --no-cache && awww clear 000000")
    hl.exec_cmd("sleep 0.1 && local_var_wallpaper-cmd")
end)
