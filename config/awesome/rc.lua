--[[

     Awesome WM configuration template
     github.com/lcpz

--]]
local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

local function center_client(c)
	local wa = awful.screen.focused().workarea
	c.x = wa.x + (wa.width - c.width) / 2
	c.y = wa.y + (wa.height - c.height) / 2
end

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- {{{ Variable definitions

local themes = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex",          -- 10
}

local chosen_theme = themes[2]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = os.getenv("TERMINAL") or "kitty"
local editor       = os.getenv("EDITOR") or "vim"
local gui_editor   = "subl3"
local browser      = "chromium"
local scrlocker    = "~/.local/bin/lock"
local mylauncher   = "~/.local/bin/h5v-launcher"
local mysymbolchooser = "~/.local/bin/symbol-chooser"

awful.util.terminal = terminal
awful.util.tagnames = { "🌎", "📟", "📝", "🌀", "📕", "🐙" }
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

beautiful.notification_icon_size = 32

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    awful.key({ }, "Print", function() 
        awful.spawn.with_shell("mkdir -p ~/Pictures/Screenshots; flameshot gui") 
    end, {description = "take a screenshot", group = "hotkeys"}),

    awful.key({ modkey }, "Print", function() awful.spawn("flameshot launcher") end,
              {description = "take a screenshot (with options)", group = "hotkeys"}),

    awful.key({ "Shift" }, "Print", function() 
        awful.spawn.with_shell([[
            mkdir -p ~/Pictures/Screenshots
            wclass=$(xdotool getactivewindow getwindowclassname)
            scrot -u "$HOME/Pictures/Screenshots/${wclass}_%Y-%m-%d_%H-%M.png" -e "notify-send Screenshot 'Saved at \$f'"
        ]])
    end, {description = "Screenshot active window", group = "hotkeys"}),

    -- X screen locker
    awful.key({ altkey, "Control" }, "l", function () awful.spawn.with_shell(scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),

    -- lock to greeter
    awful.key({ modkey, "Control" }, "l", function() awful.spawn("dm-tool switch-to-greeter") end,
              {description = "switch user", group = "hotkeys"}),

    -- Hotkeys
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    -- awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              -- {description = "view  previous nonempty", group = "tag"}),
    -- awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              -- {description = "view  previous nonempty", group = "tag"}),

    --[-[ Default client focus
    awful.key({ modkey, }, "Next",
        function ()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, }, "Prior",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --]]

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    --[[ Assigned to rofi drun
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    --]]
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.bydirection("down")    end,
              {description = "swap with lower client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.bydirection("up")    end,
              {description = "swap with upper client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.bydirection("left")    end,
              {description = "swap with left client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.bydirection("right")    end,
              {description = "swap with right client", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift"   }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On the fly useless gaps change
    -- awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              -- {description = "increment useless gaps", group = "tag"}),
    -- awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              -- {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey }, "]",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey }, "[",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "]",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "[",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    --[[awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),
    --]]
    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () 
        awful.spawn("xbacklight -inc 10") 
        awful.spawn("ddcutil -b 4 setvcp 0x10 + 10") 
    end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () 
        awful.spawn("xbacklight -dec 10") 
        awful.spawn("ddcutil -b 4 setvcp 0x10 - 10") 
    end,
              {description = "-10%", group = "hotkeys"}),

    -- PulseAudio volume control
    awful.key({ modkey }, "=",
        function ()
            awful.spawn("pamixer -i 3")
            beautiful.volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ modkey }, "-",
        function ()
            awful.spawn("pamixer -d 3")
            beautiful.volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ modkey }, "v",
        function ()
            awful.spawn("pamixer -t")
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),

    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.spawn("pamixer -i 3")
            beautiful.volume.update()
        end,
        {description = "+3%", group = "hotkeys"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.spawn("pamixer -d 3")
            beautiful.volume.update()
        end,
        {description = "-3%", group = "hotkeys"}),
    awful.key({ }, "XF86AudioMicMute",
        function ()
            awful.spawn("thinkpad-mutemic")
        end,
        {description = "toggle mute", group = "hotkeys"}),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.spawn("pamixer -t")
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),

    -- MPRIS player volume control
    awful.key({ modkey, "Shift" }, "=",
        function () awful.spawn("playerctl volume 0.05+") end,
        {description = "Player volume up", group = "widgets"}),
    awful.key({ modkey, "Shift" }, "-",
        function () awful.spawn("playerctl volume 0.05-") end,
        {description = "Player volume down", group = "widgets"}),

    --[-[ Player control (MPRIS), XF86- keys
    awful.key({ }, "XF86AudioNext",
        function ()
            awful.spawn("playerctl next")
        end,
        {description = "next track", group = "widgets"}),
    awful.key({ }, "XF86AudioPrev",
        function ()
            awful.spawn("playerctl previous")
        end,
        {description = "previous track", group = "widgets"}),
    awful.key({ "Control" }, "XF86AudioNext",
        function ()
            awful.spawn("playerctl position 5+")
        end,
        {description = "seek +5s", group = "widgets"}),
    awful.key({ "Control" }, "XF86AudioPrev",
        function ()
            awful.spawn("playerctl position -5")
        end,
        {description = "seek -5s", group = "widgets"}),
    awful.key({ }, "XF86AudioPlay",
        function ()
            awful.spawn("playerctl play-pause")
        end,
        {description = "play/pause", group = "widgets"}),
    --]]

    --[-[ Player control (MPRIS) without XF86- keys
    awful.key({ modkey }, "F12",
        function ()
            awful.spawn("playerctl next")
        end,
        {description = "next track", group = "widgets"}),
    awful.key({ modkey }, "F10",
        function ()
            awful.spawn("playerctl previous")
        end,
        {description = "previous track", group = "widgets"}),
    awful.key({ modkey }, "F9",
        function ()
            awful.spawn("playerctl position 5+")
        end,
        {description = "seek +5s", group = "widgets"}),
    awful.key({ modkey }, "F8",
        function ()
            awful.spawn("playerctl position 5-")
        end,
        {description = "seek -5s", group = "widgets"}),
    awful.key({ modkey }, "F11",
        function ()
            awful.spawn("playerctl play-pause")
        end,
        {description = "play/pause", group = "widgets"}),
    --]]

    -- MPD control
    --[[
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.spawn("mpc toggle")
            beautiful.mpd.update()
        end,
        {description = "mpc toggle", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.spawn("mpc stop")
            beautiful.mpd.update()
        end,
        {description = "mpc stop", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.spawn("mpc prev")
            beautiful.mpd.update()
        end,
        {description = "mpc prev", group = "widgets"}),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.spawn("mpc next")
            beautiful.mpd.update()
        end,
        {description = "mpc next", group = "widgets"}),
    awful.key({ altkey }, "0",
        function ()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end,
        {description = "mpc on/off", group = "widgets"}),
    --]]

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    --[[ User programs
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),
    awful.key({ modkey }, "a", function () awful.spawn(guieditor) end,
              {description = "run gui editor", group = "launcher"}),
    --]]
    -- File browser
    awful.key({ modkey }, "f", function () awful.spawn('rofi -show file-browser-extended') end,
      {description = "file browser", group = "launcher"}),

    -- Default
    --[[ Menubar 
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    --]]
    --[[ dmenu
    awful.key({ modkey }, "r", function ()
            awful.spawn(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]]
    --[[ Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    --]]
    --[-[ Rofi
    awful.key({ modkey }, "r", function () awful.spawn('rofi -show run') end,
      {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "p", function () awful.spawn('rofi -show drun -show-icons') end,
      {description = "launch application", group = "launcher"}),
    awful.key({ modkey }, "w", function () awful.spawn('rofi -show window') end,
      {description = "switch windows", group = "launcher"}), 
    awful.key({ modkey }, "u", function () awful.spawn('rofimoji') end,
      {description = "switch windows", group = "launcher"}),
    awful.key({ modkey }, "i", function () awful.spawn.with_shell(mysymbolchooser) end,
      {description = "symbol chooser", group = "launcher"}),
    awful.key({ modkey }, "x", function () awful.spawn.with_shell(mylauncher) end,
      {description = "custom launcher", group = "launcher"}),
    --]]

--     awful.key({ modkey }, "x",
--               function ()
--                   awful.prompt.run {
--                     prompt       = "Run Lua code: ",
--                     textbox      = awful.screen.focused().mypromptbox.widget,
--                     exe_callback = awful.util.eval,
--                     history_path = awful.util.get_cache_dir() .. "/history_eval"
--                   }
--               end,
--               {description = "lua execute prompt", group = "awesome"}),
    --]]

    --[-[ Window transparency control (needs transset-df)
        awful.key({ modkey, "Control" }, "-", function () awful.spawn('transset-df -a --dec 0.1') end,
          {description = "window transparency +10%", group = "client"}),
        awful.key({ modkey, "Control" }, "=", function () awful.spawn('transset-df -a --inc 0.1') end,
          {description = "window transparency -10%", group = "client"})
    --]]
)

clientkeys = my_table.join(
    awful.key({ modkey, "Shift"   }, "m",      function(c)
        c.maximized = false
        lain.util.magnify_client(c)
    end, {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space", function(c)
					awful.client.floating.toggle()
					if client.focus.y <= 0 then center_client(c) end
				end,
              {description = "toggle floating", group = "client"}),
    --[-[ Moving / Resizing
    awful.key({ modkey, altkey }, "h", function (c) c.x = c.x - 100 end,
              {description = "move left", group = "client"}),
    awful.key({ modkey, altkey }, "l", function (c) c.x = c.x + 100 end,
              {description = "move right", group = "client"}),
    awful.key({ modkey, altkey }, "k", function (c) c.y = c.y - 100 end,
              {description = "move up", group = "client"}),
    awful.key({ modkey, altkey }, "j", function (c) c.y = c.y + 100 end,
              {description = "move down", group = "client"}),
    --]]
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end

    local key = "#" .. i + 9
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, key,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, key,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, key,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- Set Firefox to always map on the first tag on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = awful.util.tagnames[1] } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },

    { rule = { class = "Zathura" },
          properties = { maximized = true } },

    { rule = { class = "TelegramDesktop" },
      properties = { screen = 1, tag = awful.util.tagnames[2] } },

    -- Slack   -> [3]
    { rule = { class = "Slack" },
      properties = { screen = 1, tag = awful.util.tagnames[3] } },
    -- Thunderbird -> [3]
    { rule = { class = "Thunderbird" },
      properties = { screen = 1, tag = awful.util.tagnames[3] } },
    -- Pycharm -> [4]
    { rule = { class = "jetbrains-pycharm" },
      properties = { screen = 1, tag = awful.util.tagnames[4] } },
    -- Zeal    -> [5]
    { rule = { class = "Zeal" },
      properties = { screen = 1, tag = awful.util.tagnames[5] } },
    -- Kraken -> [6]
    { rule = { class = "GitKraken" },
      properties = { screen = 1, tag = awful.util.tagnames[6] } },
    -- Tilda workaround
    { rule = { class = "Tilda" },
      properties = { floating = true } },
    { rule = { class = "Guake" },
      properties = { floating = true } },
    { rule = { class = "TeamViewer" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = true})
-- end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
