local gtable = require("gears.table")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- options
local spacing = beautiful.tasklist_spacing or dpi(4)
local align = beautiful.tasklist_align or "center"
local fg_normal = beautiful.tasklist_fg_normal or M.x.on_background
local bg_normal = beautiful.tasklist_bg_normal or M.x.background
local bg_focus = beautiful.tasklist_bg_focus or M.x.on_background .. M.e.dp01
local bg_urgent = beautiful.tasklist_bg_urgent or M.x.error

-- remove few symbols
beautiful.tasklist_plain_task_name=true

local tasklist_widget = {}

function tasklist_widget:buttons()
  local tasklist_buttons = gtable.join(
  awful.button({}, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end))
  return tasklist_buttons
end

function tasklist_widget:template()
  local t = {
    {
      {
        nil,
        {
          id     = 'text_role',
          widget = wibox.widget.textbox,
        },
        nil,
        layout = wibox.layout.align.horizontal,
      },
      forced_width = beautiful.tasklist_width or dpi(200),
      left = dpi(15), right = dpi(15),
      top = dpi(10), bottom = dpi(10), -- adjust in order to limit the name to one line
      widget = wibox.container.margin
    },
    id     = 'background_role',
    widget = wibox.container.background
  }
  return t
end

function tasklist_widget:new(s)
  local widget = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = self:buttons(),
    style = {
      fg_normal = fg_normal,
      bg_normal = bg_normal,
      fg_focus = fg_focus,
      bg_focus = bg_focus,
      align = align,
    },
    widget_template = self:template()
  }
  return widget
end

return setmetatable(tasklist_widget, {
  __call = tasklist_widget.new,
})
