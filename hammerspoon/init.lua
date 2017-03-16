local window = require 'hs.window'

hyper = {"ctrl", "alt"}

-- Expand / Maximize
hs.hotkey.bind(hyper, "E", nil, function()
    local win = window.focusedWindow()
    if win ~= nil then
       win:maximize()
    end
end)

-- FullScreen
hs.hotkey.bind(hyper, "f", nil, function()
    local win = window.focusedWindow()
    if win ~= nil then
        win:setFullScreen(not win:isFullScreen())
    end
end)

-- Take Left Half
hs.hotkey.bind(hyper, "j", nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Take right Half
hs.hotkey.bind(hyper, "l", nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt", "shift"}, "l", nil, function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast()
end)

hs.hotkey.bind({"ctrl", "alt", "shift"}, "j", nil, function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
end)


hs.hotkey.bind(hyper, "R", nil, function()
  hs.reload()
end)
hs.alert.show("Config loaded")
