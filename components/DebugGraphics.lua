local class = require 'middleclass/middleclass'

local DebugGraphics = class('Graphics')

function DebugGraphics:initialize(p)
   self.p = p
   self.size = self.p.att["size"]
end

function DebugGraphics:getType()
   return 'Graphics'
end

function DebugGraphics:draw()
   local t,seg = self.p.trans, 40 
   love.graphics.setColor(215,200,185,8)
   love.graphics.circle("fill", t.x, t.y, self.p.att["gravityradius"]+self.size, seg)
   love.graphics.setColor(255,0,0,255)
   love.graphics.circle("fill", t.x, t.y, self.size, seg)
   love.graphics.setColor(255,255,255,255)
end

return DebugGraphics

