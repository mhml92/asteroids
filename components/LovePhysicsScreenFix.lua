local class = require 'middleclass/middleclass'
local LovePhysicsScreenFix = class('LovePhysicsScreenFix')

function LovePhysicsScreenFix:initialize(p,offset)
   self.p = p
   self.offset = offset
end

function LovePhysicsScreenFix:getType()
   return 'ScreenFix'
end

function LovePhysicsScreenFix:update()
   local w,h = love.graphics.getDimensions()
   local o = self.offset
   local p = self.p
   if p.trans.x+o < 0 then
      p.trans.x = w+o
      p.physics.body:setX(w+o)
   end
   if p.trans.y+o < 0 then
      p.trans.y = h+o
      p.physics.body:setY(h+o)
   end
   if p.trans.x-o > w then
      p.trans.x = 0-o
      p.physics.body:setX(0-o)
   end

   if p.trans.y-o > h then
      p.trans.y = 0-o
      p.physics.body:setY(0-o)
   end
end



return LovePhysicsScreenFix
