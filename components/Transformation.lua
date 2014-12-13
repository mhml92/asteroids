local class = require 'middleclass'

local Transformation = class('Transformation')

function Transformation:initialize(x,y,r)
   self.x = x
   self.y = y
   self.r = r
end

function Transformation:getType()
   return 'Transformation'
end

function Transformation:getX()
   return self.x
end

function Transformation:getY()
   return self.y
end

function Transformation:getR()
   return self.r
end

function Transformation:setX(x)
   self.x = x
end

function Transformation:setY(y)
   self.y = y
end

function Transformation:setX(r)
   self.r = r
end
return Transformation
