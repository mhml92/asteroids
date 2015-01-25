local class = require 'middleclass'
local Physics = class('Physics')

function Physics:initialize(p,mass,force,size)

   self.p = p
   self.mass = mass
   self.force = force
   self.radius = size

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"dynamic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   --print(self.body:getMassData( ))
   self.body:resetMassData()
   self.body:setMass(self.mass)
   self.body:setLinearDamping(1)
   --print(self.body:getMassData( ))
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
   
   -- update transformation
   p.trans.x, p.trans.y = self.body:getPosition()
   
   
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
   self.body:applyForce(mx * self.force,my * self.force)
end

function Physics:applyForce(x,y)
   self.body:applyForce(x,y)
end


return Physics
