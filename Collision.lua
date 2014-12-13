local class = require 'middleclass'
local Collision = class('Collision')

function Collision:initialize(gs)
   self.gs = gs
end

function Collision:collides(go1, go2)
   dist = math.sqrt((go2.trans.x - go1.trans.x)^2 
      + (go2.trans.y-go1.trans.y)^2)
   if dist < go1.collider.r + go2.collider.r then
      return true
   end

   return false

end

return Collision
