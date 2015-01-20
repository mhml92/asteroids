local class = require 'middleclass'

local DebugGraphics = class('DebugGraphics')

function DebugGraphics:initialize(r,g,b)
   self.r = r
   self.g = g
   self.b = b
end

function DebugGraphics:getType()
   return 'Graphics'
end

function DebugGraphics:draw(p)
   love.graphics.setColor(self.r,self.g,self.b) 
   love.graphics.circle("fill", p.trans.x, p.trans.y, p.colsys.collider.r, 100)  
   
   love.graphics.setColor(0, 255, 0) 
   -- DRAW VELOCITY
   --love.graphics.line( p.trans.x, p.trans.y, p.trans.x+p.physics.vel.x, p.trans.y+p.physics.vel.y)
  
   -- DRAW R
   love.graphics.line( p.trans.x, p.trans.y, p.trans.x+20*math.cos(p.trans.r), p.trans.y+20*math.sin(p.trans.r))

   love.graphics.setColor(255,255,255)
  -- love.graphics.setColor(0, 0, 255)
  -- local r = math.atan2(p.controller.shootDir.y,p.controller.shootDir.x)
   --love.graphics.line( p.trans.x, p.trans.y, p.trans.x+20*math.cos(r), p.trans.y+20*math.sin(r))

end

return DebugGraphics
