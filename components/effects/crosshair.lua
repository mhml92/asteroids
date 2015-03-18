local class = require 'middleclass/middleclass'
local Crosshair = class('Crosshair')

function Crosshair:initialize(img)
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

function Crosshair:update(p)
   local pos = {}
   pos.x = p.trans.x
   pos.y = p.trans.y
   local dir = p.controller.shootDir
   local len = math.sqrt(dir.x^2 + dir.y^2)
   dir.x = dir.x/len
   dir.y = dir.y/len
   local dist = 150
   self.x = (pos.x + dist *dir.x)-self.w
   self.y = (pos.y + dist *dir.y)-self.h

end

function Crosshair:draw(p)
   
   love.graphics.draw( self.img,self.x,self.y)
end
return Crosshair
