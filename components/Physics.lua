local class = require 'middleclass'
local Physics = class('Physics')

function Physics:initialize(mass,force,friction)

   self.friction = friction
   self.force = force
   self.mass = mass


   self.vel = {}
   self.vel.x = 0
   self.vel.y = 0
   self.dv = {}
   self.dv.x = 0
   self.dv.y = 0

end

function Physics:getType()
   return 'Physics'
end

function Physics:update(p)
   
   local mx = 0
   local my = 0
   if p.controller ~= nil then
      if p.controller.moveDir.x ~= 0 or p.controller.moveDir.y ~= 0 then 
         p.trans.r = math.atan2(p.controller.moveDir.y,p.controller.moveDir.x)
         mx = p.controller.moveDir.x
         my = p.controller.moveDir.y
      end
   end
   
   if self.dv.x ~= 0 and self.dv.y ~= 0 then
      self.vel.x = self.vel.x + self.dv.x
      self.vel.y = self.vel.y + self.dv.y
      self.dv.x = 0
      self.dv.y = 0
   end
   self.vel.x = self.vel.x + (mx * self.force) 
   self.vel.y = self.vel.y + (my * self.force)
   
   --reset dv
   
   
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

function Physics:applyForce(x,y)
   self.dv.x =  x
   self.dv.y =  y
end


return Physics
