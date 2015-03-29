local class = require 'middleclass/middleclass'

local Graphics = class('Graphics')

function Graphics:initialize(p,img, scale)
   local id = p.id
   self.p = p
   self.img = img
   self.foreground = {}
   self.background = {}
   -- scale == width in px
   self.scale = scale/img:getWidth()
end

function Graphics:getType()
   return 'Graphics'
end

function Graphics:addBackgound(img)
   table.insert(self.background,img)
end
function Graphics:addForeground(img)
   table.insert(self.foreground,img)
end


function Graphics:draw()
   for i = #self.background,1,-1 do
      love.graphics.draw(self.background[i], self.p.trans.x, self.p.trans.y, self.p.trans.r, self.scale, self.scale, self.background[i]:getWidth()/2, self.background[i]:getHeight()/2, 0, 0 )
   end

   love.graphics.draw(self.img, self.p.trans.x, self.p.trans.y, self.p.trans.r, self.scale, self.scale, self.img:getWidth()/2, self.img:getHeight()/2, 0, 0 )
   
   for i = #self.foreground,1,-1 do
      love.graphics.draw(self.foreground[i], self.p.trans.x, self.p.trans.y, self.p.trans.r, self.scale, self.scale, self.img:getWidth()/2, self.img:getHeight()/2, 0, 0 )
   end
end



return Graphics
