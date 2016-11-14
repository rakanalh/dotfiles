local window = require 'hs.window'

-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Expand / Maximize
k:bind({}, "E", nil, function()
    local win = window.focusedWindow()
    if win ~= nil then
       win:maximize()
    end
end)

-- FullScreen
k:bind({}, "F", nil, function()
    local win = window.focusedWindow()
    if win ~= nil then
        win:setFullScreen(not win:isFullScreen())
    end
end)

-- Take Left Half
k:bind({}, "Left", nil, function()
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
k:bind({}, "Right", nil, function()
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

k:bind({}, "N", nil, function()
  local win = hs.window.focusedWindow()
  win:moveOnScreenEast()
end)
  

k:bind({}, "R", nil, function()
  hs.reload()
end)
hs.alert.show("Config loaded")

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
