local class = require 'middleclass/middleclass'
local Crosshair = class('Crosshair')

function Crosshair:initialize(p,img)
   self.p = p
   self.img = img
   self.x = 0
   self.y = 0
   self.w,self.h = self.img:getDimensions()

   self.w = self.w/2
   self.h = self.h/2
end

function Crosshair:getType()
   return "Effect"
end   

function Crosshair:update()
   local pos = self.p.trans
   local dist = 150
   self.x = (pos.x + dist *math.cos(pos.r))-self.w
   self.y = (pos.y + dist *math.sin(pos.r))-self.h

end

function Crosshair:draw(p)
   
   love.graphics.draw( self.img,self.x,self.y)
end
return Crosshair
