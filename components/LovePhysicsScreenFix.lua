local class = require 'middleclass'
local ScreenFix = class('ScreenFix')

function ScreenFix:initialize()

end

function ScreenFix:getType()
   return 'ScreenFix'
end

function ScreenFix:update(p)
   local w,h = love.graphics.getDimensions()
   if p.trans.x < 0 then
      p.trans.x = w
      p.physics.body:setX(w)
   end
   if p.trans.y < 0 then
      p.trans.y = h
      p.physics.body:setY(h)
   end
   if p.trans.x > w then
      p.trans.x = 0
      p.physics.body:setX(0)
   end

   if p.trans.y > h then
      p.trans.y = 0
      p.physics.body:setY(0)
   end
end



return ScreenFix
