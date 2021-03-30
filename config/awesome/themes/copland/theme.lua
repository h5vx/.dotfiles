--[[

     Copland Awesome WM theme 2.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local awesome, client, os = awesome, client, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/copland"
theme.wallpaper                                 = { theme.dir .. "/wall.png", theme.dir .. "/wall2.png" }
-- theme.font                                      = "Fura Code 11"
theme.size_multiplier				= 1.33
theme.font                                      = "Varela Round 11"
theme.widget_font                               = "FuraCode Nerd Font 10"
theme.fg_normal                                 = "#BBBBBB"
theme.fg_focus                                  = "#C708C4"
theme.bg_normal                                 = "#0C0E15"
theme.bg_focus                                  = "#0C0E15"
theme.fg_urgent                                 = "#BBBBBB"
theme.bg_urgent                                 = "#444444"
theme.border_width                              = 1
theme.border_normal                             = "#141414"
theme.border_focus                              = "#C708C4"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.taglist_bg_focus                          = "#660033"
theme.taglist_bg_normal                         = "#0C0E15"
theme.titlebar_bg_normal                        = "#191919"
theme.titlebar_bg_focus                         = "#262626"
theme.menu_height                               = 16
theme.menu_width                                = 130
theme.tasklist_disable_icon                     = true
theme.awesome_icon                              = theme.dir .."/icons/awesome.png"
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_unsel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.vol                                       = theme.dir .. "/icons/vol.png"
theme.vol_low                                   = theme.dir .. "/icons/vol_low.png"
theme.vol_no                                    = theme.dir .. "/icons/vol_no.png"
theme.vol_mute                                  = theme.dir .. "/icons/vol_mute.png"
theme.disk                                      = theme.dir .. "/icons/disk.png"
theme.mem                                       = theme.dir .. "/icons/mem.png"
theme.ac                                        = theme.dir .. "/icons/ac.png"
theme.bat                                       = theme.dir .. "/icons/bat.png"
theme.bat_low                                   = theme.dir .. "/icons/bat_low.png"
theme.bat_no                                    = theme.dir .. "/icons/bat_no.png"
theme.play                                      = theme.dir .. "/icons/play.png"
theme.pause                                     = theme.dir .. "/icons/pause.png"
theme.stop                                      = theme.dir .. "/icons/stop.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.useless_gap                               = 0
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

-- lain related
theme.layout_centerfair                         = theme.dir .. "/icons/centerfair.png"
theme.layout_termfair                           = theme.dir .. "/icons/termfair.png"
theme.layout_centerwork                         = theme.dir .. "/icons/centerwork.png"

local markup = lain.util.markup
local blue   = theme.fg_focus
local red    = "#EB8F8F"
local green  = "#8FEB8F"

-- Textclock
--os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock("<span font='Misc Tamsyn 5'> </span>%d %a %H:%M ")
-- mytextclock.font = theme.font
mytextclock.font = 'Varela Round Bold 10.5'

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = theme.widget_font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
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
        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "<span font='Misc Tamsyn 5'> </span>Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup(blue, mail) .. count)
    end
})
--]]

-- MPD
local mpdicon = wibox.widget.imagebox()
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            title = mpd_now.title
            artist  = " " .. mpd_now.artist  .. markup("#777777", " <span font='Misc Tamsyn 2'> </span>|<span font='Misc Tamsyn 5'> </span>")
            mpdicon:set_image(theme.play)
        elseif mpd_now.state == "pause" then
            title = "mpd "
            artist  = "paused" .. markup("#777777", " |<span font='Misc Tamsyn 5'> </span>")
            mpdicon:set_image(theme.pause)
        else
            title  = ""
            artist = ""
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end

        widget:set_markup(markup.font(theme.font, markup(blue, title) .. artist))
    end
})

local function format_size_mb(size_mb)
    size = size_mb
    grade = "M"

    if (size_mb >= 1024) then 
        grade = "G" 
        size = string.format("%.1f", size_mb / 1024)
    end
    
    return size .. grade .. " "
end

-- MEM
local mem_font = theme.widget_font
local memicon = wibox.widget.imagebox(theme.mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(mem_font, theme.border_focus, format_size_mb(mem_now.used)))
    end
})

local swap = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(mem_font, '#c0B670', format_size_mb(mem_now.swapused)))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.bat)
local batbar = wibox.widget {
    forced_height    = 1,
    forced_width     = 59 * theme.size_multiplier,
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6 * theme.size_multiplier + 2,
    widget           = wibox.widget.progressbar,
}
local batupd = lain.widget.bat({
    settings = function()
        if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end

        if bat_now.status == "Charging" then
            baticon:set_image(theme.ac)
            if bat_now.perc >= 98 then
                batbar:set_color(green)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
            else
                batbar:set_color(red)
            end
        else
            if bat_now.perc >= 98 then
                batbar:set_color(green)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
                baticon:set_image(theme.bat)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
                baticon:set_image(theme.bat_low)
            else
                batbar:set_color(red)
                baticon:set_image(theme.bat_no)
            end
        end
        batbar:set_value(bat_now.perc / 100)
    end
})
local batbg = wibox.container.background(batbar, "#474747", gears.shape.rectangle)
local batwidget = wibox.container.margin(batbg, 2, 7, 4, 4)

-- /home fs
--[[ commented because it needs Gio/Glib >= 2.54
local fsicon = wibox.widget.imagebox(theme.disk)
local fsbar = wibox.widget {
    forced_height    = 1,
    forced_width     = 59,
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6,
    widget           = wibox.widget.progressbar,
}
theme.fs = lain.widget.fs {
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Misc Tamsyn 10.5" },
    settings  = function()
        if fs_now["/home"].percentage < 90 then
            fsbar:set_color(theme.fg_normal)
        else
            fsbar:set_color("#EB8F8F")
        end
        fsbar:set_value(fs_now["/home"].percentage / 100)
    end
}
local fsbg = wibox.container.background(fsbar, "#474747", gears.shape.rectangle)
local fswidget = wibox.container.margin(fsbg, 2, 7, 4, 4)
--]]

-- ALSA volume bar
local volicon = wibox.widget.imagebox(theme.vol)
theme.volume = lain.widget.pulsebar {
    width = 59 * theme.size_multiplier, border_width = 0, ticks = true, ticks_size = 6 * theme.size_multiplier + 2,
    notification_preset = { font = theme.font },
    settings = function()
        vlevel = tonumber(volume_now.left)
        if volume_now.muted == "yes" then
            volicon:set_image(theme.vol_mute)
        elseif vlevel == 0 then
            volicon:set_image(theme.vol_no)
        elseif vlevel <= 50 then
            volicon:set_image(theme.vol_low)
        else
            volicon:set_image(theme.vol)
        end
    end,
    colors = {
        background   = theme.bg_normal,
        mute         = red,
        unmute       = theme.fg_normal
    }
}
theme.volume.tooltip.wibox.fg = theme.fg_focus
-- theme.volume.bar:buttons(my_table.join (
--           awful.button({}, 1, function()
--             awful.spawn(string.format("%s -e alsamixer", awful.util.terminal))
--           end),
--           awful.button({}, 2, function()
--             os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 3, function()
--             os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 4, function()
--             os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 5, function()
--             os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end)
-- ))
local volumebg = wibox.container.background(theme.volume.bar, "#474747", gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, 2, 7, 4, 4)

-- Weather
theme.weather = lain.widget.weather({
    city_id = 479561,
    notification_preset = { font = theme.widget_font },
    lang = "ru",
    settings = function()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(" " .. markup.font(theme.font, units .. "°C") .. " ")
    end
})

-- Separators
local first     = wibox.widget.textbox(markup.font("Misc Tamsyn 3", " "))
local spr       = wibox.widget.textbox(' ')
local small_spr = wibox.widget.textbox(markup.font("Misc Tamsyn 4", " "))
local bar_spr   = wibox.widget.textbox(markup.font("Misc Tamsyn 3", " ") .. markup.fontfg(theme.font, "#777777", "|") .. markup.font("Misc Tamsyn 5", " "))
local swap_label = wibox.widget.textbox(markup.font(mem_font, "╱ "))

-- Eminent-like task filtering
local orig_filter = awful.widget.taglist.filter.all

-- Taglist label functions
awful.widget.taglist.filter.all = function (t, args)
    if t.selected or #t:clients() > 0 then
        return orig_filter(t, args)
    end
end

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end

    if type(wallpaper) == "table" then
        wallpaper = wallpaper[s.index]
    end

    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 18 * theme.size_multiplier, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            small_spr,
            s.mylayoutbox,
            first,
            bar_spr,
            s.mytaglist,
            first,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            small_spr,
            --theme.mail.widget,
            mpdicon,
            theme.mpd.widget,
            -- bar_spr,
            -- theme.weather.icon,
            -- theme.weather.widget,
            memicon,
            memory,
            swap_label,
            swap,
            --fsicon,
            --fswidget,
            -- bar_spr,
            baticon,
            batwidget,
            volicon,
            volumewidget,
            -- bar_spr,
            mytextclock,
        },
    }
end

return theme
