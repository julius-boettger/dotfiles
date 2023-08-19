--[[

     Theme of github.com/julius-boettger
     Based on: Rainbow Awesome WM theme 2.0 of github.com/lcpz

--]]

-- color scheme based on vscode theme "monokai pro (filter spectrum)"
local colors = {
    "#FC618D", -- r
    "#7BD88F", -- g
    "#FD9353", -- y
    "#5AA0E6", -- b
    "#948AE3", -- m
    "#5AD4E6"  -- c
}

-- available .png wallpapers in themedir/wallpapers/
local wallpapers = {
    "rb",
    "ry",
    "rb",
    "rm",
    "rc",
    "gy",
    "gb",
    "gm",
    "gc",
    "yb",
    "ym",
    "yc",
    "bm",
    "bc",
    "mc"
}

-- set random seed based on time
math.randomseed(os.time())
-- choose random theming variant
local variant = {
    accent_color = colors    [math.random(1, #colors    )],
    wallpaper    = wallpapers[math.random(1, #wallpapers)]
}

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/mytheme"
theme.wallpaper                                 = theme.dir .. "/wallpapers/" .. variant.wallpaper .. ".png"
theme.font                                      = "FiraCode Nerd Font 12"
theme.bg_urgent                                 = "#FFFFFF"
theme.taglist_fg_focus                          = "#F7F1FF"
theme.fg_focus                                  = "#F7F1FF"
theme.border_focus                              = "#F7F1FF"
theme.fg_normal                                 = "#8C8A8F"
theme.bg_normal                                 = "#262527"
theme.bg_focus                                  = "#262527"
theme.border_normal                             = "#262527"
theme.taglist_bg_focus                          = "#262527"
theme.fg_urgent                                 = "#201F21"
theme.border_width                              = dpi(1)
theme.useless_gap                               = dpi(5)
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.ocol                                      = "<span color='" .. theme.fg_normal .. "'>"
theme.tasklist_floating                         = theme.ocol .. "*</span>"
theme.tasklist_maximized                        = theme.ocol .. "+</span>"
theme.tasklist_maximized_horizontal             = theme.ocol .. "+</span>"
theme.tasklist_maximized_vertical               = theme.ocol .. "+</span>"
theme.tasklist_sticky                           = theme.ocol .. "[s] </span>"
theme.tasklist_ontop                            = theme.ocol .. "[t] </span>"
theme.tasklist_disable_icon                     = true
theme.awesome_icon                              = theme.dir .."/icons/awesome.png"
theme.menu_submenu_icon                         = theme.dir .."/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.layout_txt_tile                           = "[t]"
theme.layout_txt_tileleft                       = "[l]"
theme.layout_txt_tilebottom                     = "[b]"
theme.layout_txt_tiletop                        = "[tt]"
theme.layout_txt_fairv                          = "[fv]"
theme.layout_txt_fairh                          = "[fh]"
theme.layout_txt_spiral                         = "[s]"
theme.layout_txt_dwindle                        = "[d]"
theme.layout_txt_max                            = "[m]"
theme.layout_txt_fullscreen                     = "[F]"
theme.layout_txt_magnifier                      = "[M]"
theme.layout_txt_floating                       = "[*]"
theme.titlebar_close_button_normal              = theme.default_dir.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.default_dir.."/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.default_dir.."/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.default_dir.."/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.default_dir.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.default_dir.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.default_dir.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.default_dir.."/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.default_dir.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.default_dir.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.default_dir.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.default_dir.."/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.default_dir.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.default_dir.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.default_dir.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.default_dir.."/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_dir.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.default_dir.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.default_dir.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.default_dir.."/titlebar/maximized_focus_active.png"

-- lain related
theme.layout_txt_cascade                        = "[cascade]"
theme.layout_txt_cascadetile                    = "[cascadetile]"
theme.layout_txt_centerwork                     = "[centerwork]"
theme.layout_txt_termfair                       = "[termfair]"
theme.layout_txt_centerfair                     = "[centerfair]"

local markup = lain.util.markup

-- Textclock
local mytextclock = wibox.widget.textclock(markup(theme.fg_focus, "%H:%M"))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font     = theme.font,
        fg       = theme.fg_focus,
        bg       = theme.bg_normal,
        position = "top_right"
    }
})

-- Mail IMAP check
--[[ commented because it needs to be set before use
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = theme.fg_focus

        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(theme.fg_normal, mail) .. markup(theme.fg_focus, count)))
    end
})
--]]

-- MPD
--theme.mpd = lain.widget.mpd({
--    settings = function()
--        mpd_notification_preset.fg = theme.fg_focus
--
--        artist = mpd_now.artist .. " "
--        title  = mpd_now.title  .. " "
--
--        if mpd_now.state == "pause" then
--            artist = "mpd "
--            title  = "paused "
--        elseif mpd_now.state == "stop" then
--            artist = ""
--            title  = ""
--        end
--
--        widget:set_markup(markup.font(theme.font, markup(theme.fg_normal, artist) .. markup(theme.fg_focus, title)))
--    end
--})

-- /home fs
--[[ commented because it needs Gio/Glib >= 2.54
theme.fs = lain.widget.fs({
    notification_preset = { fg = theme.fg_focus, bg = theme.bg_normal, font = "Terminus 10.5" },
    settings  = function()
        local fs_header, fs_p = "", ""

        if fs_now["/home"].percentage >= 90 then
            fs_header = " Hdd "
            fs_p      = fs_now["/home"].percentage
        end

        widget:set_markup(markup.font(theme.font, markup(theme.fg_normal, fs_header) .. markup(theme.fg_focus, fs_p)))
    end
})
--]]

-- ALSA volume bar
theme.volume = lain.widget.alsabar({
    ticks = true,
    width = dpi(56),
    ticks_size = dpi(10),
    margins = 1,
    notification_preset = { font = theme.font },
    colors = {
        background = theme.bg_normal,
        mute = theme.fg_normal,
        unmute = variant.accent_color
    }
})
-- doesnt work?
--theme.volume.tooltip.wibox.fg = "#00ff00"
--theme.volume.tooltip.wibox.bg = "#ff00ff"
theme.volume.tooltip.wibox.font = theme.font
theme.volume.bar:buttons(my_table.join(
    awful.button({}, 1, function()
        --awful.spawn(string.format("%s -e alsamixer", terminal))
        -- copied functionality of right-click
        os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
        theme.volume.update()
    end),
    awful.button({}, 2, function()
        os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
    end),
    awful.button({}, 3, function()
        os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
        theme.volume.update()
    end),
    awful.button({}, 4, function()
        os.execute(string.format("%s set %s 5%%+", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
    end),
    awful.button({}, 5, function()
        os.execute(string.format("%s set %s 5%%-", theme.volume.cmd, theme.volume.channel))
        theme.volume.update()
    end)
))
local volumebg = wibox.container.background(theme.volume.bar, theme.fg_normal, gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, dpi(7), dpi(7), dpi(5), dpi(5))

-- Weather
--[[ to be set before use
theme.weather = lain.widget.weather({
    --APPID =
    city_id = 2643743, -- placeholder (London)
    notification_preset = { font = theme.font, fg = theme.fg_focus }
})
--]]

-- Separators
local first = wibox.widget.textbox(markup.font("Terminess Nerd Font 4", " "))
local spr   = wibox.widget.textbox(" ")
local bar   = wibox.widget.textbox(markup.fontfg(theme.font, theme.fg_focus, "|"))

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

-- Memory
local memicon = wibox.container.margin(wibox.widget.imagebox(theme.widget_mem), 0, 0, dpi(4), dpi(4))
local memory = lain.widget.mem({
    settings = function()
        local mem = math.floor(mem_now.used * ((2^20) / (10^6)))
        widget:set_markup(markup.font(theme.font, markup(theme.fg_focus, mem) .. "MB"))
    end
})

-- CPU
local cpuicon = wibox.container.margin(wibox.widget.imagebox(theme.widget_cpu), 0, 0, dpi(5), dpi(5))
local cpu = lain.widget.sysload({
    settings = function()
        -- cpu load average over 1 minute with 2 decimals
        local current_load = tonumber(load_1)
        -- set to 0 if nil
        if not current_load then
            current_load = 0
        end

        -- display 2 decimals
        local text = string.format("%.2f", current_load)

        -- round to 1 decimal if >= 10
        if current_load >= 10 then
            text = string.format("%.1f", current_load)
            -- display no decimals if rounded to 100%
            if current_load >= 99.95 then
                text = string.format("%.0f", current_load)
            end
        end
        widget:set_markup(markup.font(theme.font, markup(theme.fg_focus, text) .. "%"))
    end
})

function theme.at_screen_connect(s)

    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt({
        prompt = "> ",
        --with_shell = true
    })

    -- Textual layoutbox
    s.mytxtlayoutbox = wibox.widget.textbox(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
    s.mytxtlayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function() awful.layout.inc(1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function() awful.layout.inc(-1) end),
                           awful.button({}, 4, function() awful.layout.inc(1) end),
                           awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(
        s,
        awful.widget.tasklist.filter.currenttags,
        awful.util.tasklist_buttons,
        {
            align = "left",
            bg_normal = theme.fg_urgent,
            bg_focus = theme.fg_urgent,
            shape = gears.shape.rectangle,
            shape_border_color = theme.bg_normal,
            shape_border_width = 3,
        }
    )

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(25), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,

            first,
            s.mytaglist,

            spr,

            cpuicon, spr,
            cpu.widget,

            spr, spr, spr,

            memicon, spr,
            memory.widget,

            spr, spr,

            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            spr,

            layout = wibox.layout.fixed.horizontal,

            spr,

            wibox.widget.systray(),
            --theme.mpd.widget,
            --theme.mail.widget,
            --theme.fs.widget,

            spr,

            s.mytxtlayoutbox,
            volumewidget,
            mytextclock,

            spr, spr
        },
    }
end

return theme
