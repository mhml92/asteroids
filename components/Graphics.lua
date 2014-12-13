local class = require 'middleclass'

local Graphics = class('Graphics')

function Graphics:initialize(img, scale)
   self.img = img
   self.scale = scale
end

function Graphics:getType()
   return 'Graphics'
end

function Graphics:draw(p)
   love.graphics.setColor(255,255,255)
   love.graphics.draw( self.img, p.trans.x, p.trans.y, p.trans.r+((1/2)*math.pi), self.scale, self.scale, self.img:getWidth()/2, self.img:getHeight()/2, 0, 0 )
   --love.graphics.setColor(255,255,255,128)
   --love.graphics.circle("fill", p.trans.x, p.trans.y, p.collider.r, 100)  
   --love.graphics.setColor(255,255,255,0)
end

return Graphics
