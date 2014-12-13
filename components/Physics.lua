local class = require 'middleclass'
local Physics = class('Physics')

function Physics:initialize(mass,force,friction,maxspeed)

   self.friction = friction
   self.force = force
   self.mass = mass

   self.maxspeed = maxspeed

   self.vel = {}
   self.vel.x = 0
   self.vel.y = 0

end

function Physics:getType()
   return 'Physics'
end

function Physics:update(p)
   
   local mx = 0
   local my = 0
   
   if p.controller.moveDir.x ~= 0 or p.controller.moveDir.y ~= 0 then 
      p.trans.r = math.atan2(p.controller.moveDir.y,p.controller.moveDir.x)
      mx = p.controller.moveDir.x
      my = p.controller.moveDir.y
   end
   
   --update velocity
   self.vel.x = self.vel.x + mx * self.force 
   self.vel.y = self.vel.y + my * self.force 
   
   --update friction
   self.vel.x = self.vel.x * self.friction
   self.vel.y = self.vel.y * self.friction
   

   if math.sqrt(self.vel.x^2 + self.vel.y^2) < 0.01 then
      self.vel.x = 0
      self.vel.y = 0
   end
  
   -- update transformation
   p.trans.x = p.trans.x + self.vel.x/self.mass
   p.trans.y = p.trans.y + self.vel.y/self.mass
end

return Physics
