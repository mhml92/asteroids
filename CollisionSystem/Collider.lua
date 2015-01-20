local class = require 'middleclass'
local Collider = class('Collider')

function Collider:initialize(radius)
   self.r = radius
end

function Collider:getType()
   return 'Collider'
end

return Collider
