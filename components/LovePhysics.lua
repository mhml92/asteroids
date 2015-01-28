local class = require 'middleclass'
local LovePhysics = class('Physics')

function LovePhysics:initialize(p,mass,force,radius,ldamping)

   self.p = p
   self.mass = mass
   self.force = force
   self.radius = radius
   self.ldamping = ldamping 
   
   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"dynamic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)

   self.body:resetMassData()
   self.body:setMass(self.mass)

   self.body:setLinearDamping(self.ldamping)
end

function LovePhysics:getType()
   return 'Physics'
end

function LovePhysics:update()
   local p = self.p
   if p.controller ~= nil then
      if p.controller.moveDir.x ~= 0 or p.controller.moveDir.y ~= 0 then 
         
         p.trans.r = math.atan2(p.controller.moveDir.y,p.controller.moveDir.x)
         
         local len,mx,my = 0
         mx = p.controller.moveDir.x
         my = p.controller.moveDir.y
         len = math.sqrt(mx^2+my^2)
         mx = mx/len
         my = my/len
         self.body:applyForce(mx * self.force, my * self.force)
      end
   end
   
   -- update transformation
   p.trans.x, p.trans.y = self.body:getPosition()
end

function LovePhysics:applyForce(x,y)
   self.body:applyForce(x,y)
end

function LovePhysics:applyLinearImpulse(x,y)
   self.body:applyLinearImpulse(x,y)
end

return LovePhysics
