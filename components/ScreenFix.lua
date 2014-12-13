local class = require 'middleclass'
local ScreenFix = class('ScreenFix')

function ScreenFix:initialize()

end

function ScreenFix:getType()
   return 'ScreenFix'
end

function ScreenFix:update(p)
   if p.trans.x < 0 then
      p.trans.x = 0
   end
   if p.trans.y < 0 then
      p.trans.y = 0
   end
   local w, h = love.graphics.getDimensions( )
   if p.trans.x > w then
      p.trans.x = w
   end

   if p.trans.y > h then
      p.trans.y = h
   end
end



return ScreenFix
