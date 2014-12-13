local class = require 'middleclass'
local ConstSpeed = class('Physics')

function ConstSpeed:initialize(speed)

   self.speed = speed

   self.vel = {}
   self.vel.x = 0
   self.vel.y = 0

end

function ConstSpeed:getType()
   return 'Physics'
end

function ConstSpeed:update(p)
   
   local mx = 0
   local my = 0
   
   if math.sqrt(p.controller.moveDir.x^2 + p.controller.moveDir.y^2) ~= 0 then 
      p.trans.r = math.atan2(p.controller.moveDir.y,p.controller.moveDir.x)
      mx = math.cos(p.trans.r)
      my = math.sin(p.trans.r)
   end
   
   --update velocity
   self.vel.x = mx * self.speed 
   self.vel.y = my * self.speed 
   
  
   -- update transformation
   p.trans.x = p.trans.x + self.vel.x
   p.trans.y = p.trans.y + self.vel.y
end

return ConstSpeed
