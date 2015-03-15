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
   --love.graphics.setColor(255,255,255)
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

return Graphics
