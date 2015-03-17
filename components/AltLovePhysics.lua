local class = require 'middleclass/middleclass'
local vector = require 'hump/vector-light'
local LovePhysics = class('Physics')

function LovePhysics:initialize(p,mass,force,radius,ldamping,maxspeed)

   self.p = p
   self.mass = mass
   self.force = force
   self.radius = radius
   self.ldamping = ldamping 
   self.maxspeed = maxspeed

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"dynamic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)

   self.body:resetMassData()
   self.body:setMass(self.mass)

   self.body:setLinearDamping(self.ldamping)

   -- EXPERIMENTAL
   self.turnspeed = (2*math.pi)/(90) 
   self.turnmomentum = 0 
end

function LovePhysics:getType()
   return 'Physics'
end

function LovePhysics:update()
   local p = self.p
   if p.controller ~= nil then
      self.turnmomentum = p.controller.moveDir.turn 
      local maxts = 1
      if(math.abs(self.turnmomentum) > maxts)then
         if self.turnmomentum < 0 then 
            self.turnmomentum = -maxts
         else
            self.turnmomentum = maxts
         end
      end


      p.trans.r = p.trans.r + self.turnmomentum * self.turnspeed 


      local moveForce = p.controller.moveDir.acc
      if moveForce >= 0 then 
         self.body:setLinearDamping(self.ldamping)
         self.body:applyForce(math.cos(p.trans.r) * moveForce*self.force, math.sin(p.trans.r) * moveForce*self.force)
         if(vector.len(self.body:getLinearVelocity()) > self.maxspeed) then
            local nx,ny = vector.normalize(self.body:getLinearVelocity())
            self.body:setLinearVelocity(nx*self.maxspeed,ny*self.maxspeed)
         end
      else 
         self.body:setLinearDamping(self.ldamping+3*math.abs( p.controller.moveDir.acc))
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
