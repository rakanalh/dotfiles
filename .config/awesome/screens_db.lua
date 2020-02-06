local naughty = require("naughty")

local defaultOutput = 'eDP-1'

outputMapping = {
   ['DP1'] = 'DP1',
   ['DP2'] = 'DP2',
   ['DP3'] = 'DP3',

   ['DP-1'] = 'DP-1',
   ['DP-2'] = 'DP-2',
   ['DP-3'] = 'DP-3',

   ['VGA-1'] = 'VGA-1',
   ['LVDS-1'] = 'LVDS-1',
   ['HDMI-A-1'] = 'HDMI-1',
   ['HDMI-A-2'] = 'HDMI-2',
   ['HDMI-1'] = 'HDMI-1',
   ['HDMI-2'] = 'HDMI-2',
   ['eDP-1'] = 'eDP-1',
   ['eDP-2'] = 'eDP-2',
}

screens = {
   ['default'] = {
      ['connected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --auto --same-as ' .. defaultOutput
         end
         return nil
      end,
      ['disconnected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
         end
         return nil
      end
   },
   ['11811111'] = { -- HOME DP-1
      ['connected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --mode 1920x1080 --pos 1920x0'
         end
         return nil
      end,
      ['disconnected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
         end
         return nil
      end
   },
   ['9011111'] = { -- HOME HDMI
      ['connected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --mode 1920x1080 --pos 3840x305'
         end
         return nil
      end,
      ['disconnected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
         end
         return nil
      end
   },
   ['10210460018'] = { -- WORK HDMI
      ['connected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' -mode 2560x1440 --pos 2560x0'
         end
         return nil
      end,
      ['disconnected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
         end
         return nil
      end
   },
   ['1021745003'] = { -- DP-1
      ['connected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --mode 2560x1440 --pos 0x0'
         end
         return nil
      end,
      ['disconnected'] = function (xrandrOutput)
         if xrandrOutput ~= defaultOutput then
            return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
         end
         return nil
      end
   }
}
