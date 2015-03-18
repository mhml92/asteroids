local class = require 'middleclass/middleclass'

local Graphics = class('Graphics')

function Graphics:initialize(p,img, scale)
   local id = p.id
   self.r,self.g,self.b = (math.random()*255),math.random()*255,math.random()*255 
   self.img = img

   -- scale == width in px
   self.scale = scale/img:getWidth()
end

function Graphics:getType()
   return 'Graphics'
end

function Graphics:draw(p)
   love.graphics.draw(self.img, p.trans.x, p.trans.y, p.trans.r+((1/2)*math.pi), self.scale, self.scale, self.img:getWidth()/2, self.img:getHeight()/2, 0, 0 )
end

return Graphics
