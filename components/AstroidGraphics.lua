local class = require 'middleclass'

local AstroidsGraphics = class('Graphics')

function AstroidsGraphics:initialize(img, scale)
   self.img = img
   self.r = math.random()* 2*math.pi
   self.spin = (math.random() * 1/(180*math.pi))-(1/2 *1/180*math.pi)
   -- scale == width in px
   self.scale = scale/img:getWidth()
end

function AstroidsGraphics:getType()
   return 'Graphics'
end

function AstroidsGraphics:draw(p)
   love.graphics.setColor(255,255,255)
   self.r = self.r + self.spin
   love.graphics.draw(self.img, p.trans.x, p.trans.y, self.r, self.scale, self.scale, self.img:getWidth()/2, self.img:getHeight()/2, 0, 0 )
   --[[
   love.graphics.setColor(255,255,255,128)
   love.graphics.line(p.trans.x,p.trans.y,p.trans.x+p.physics.vel.x,p.trans.y)
   love.graphics.line(p.trans.x,p.trans.y,p.trans.x,p.trans.y+p.physics.vel.y)
   love.graphics.setColor(255,255,255)
   love.graphics.line(p.trans.x,p.trans.y,p.trans.x+p.physics.vel.x,p.trans.y+p.physics.vel.y)
   love.graphics.setColor(255,255,255)
   --love.graphics.circle("fill", p.trans.x, p.trans.y, p.collider.r, 100)  
   --love.graphics.setColor(255,255,255,128)
   --love.graphics.circle("fill", p.trans.x, p.trans.y, p.collider.r, 100)  
   --love.graphics.setColor(255,255,255,0)
   ]]
end

return AstroidsGraphics
