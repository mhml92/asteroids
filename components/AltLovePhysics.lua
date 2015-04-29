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
   self.old_maxspeed = maxspeed

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"dynamic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)
   self.fixture:setRestitution(0.2)
   self.body:resetMassData()
   self.body:setMass(self.mass)

   self.body:setLinearDamping(self.ldamping)

   -- EXPERIMENTAL
   self.turnspeed = (2*math.pi)/(90) 
   self.turnmomentum = 0 
   
   self.boostingTime = 0
   self.currentlyBoosting = false
   self.cooldown = 0
end

function LovePhysics:getType()
   return 'Physics'
end

function LovePhysics:update()
   if self.p.controller ~= nil then
      self.turnmomentum = self.p.controller:getTurn() 
      
     
      if self.cooldown > 0 then
         self.cooldown = self.cooldown -1
      end


      if self.currentlyBoosting then
         local asize = math.max(self.p.att["size"]*((self.boostingTime)/8),self.p.att["size"]/4)
         self.p.gs.factory:createExplosion(self.p.trans.x,self.p.trans.y,asize,15*math.random(),asize*0.8,10*math.random(),asize*0.5,5*math.random())
         self.boostingTime = self.boostingTime - 1
         if self.boostingTime == 0 then
            self.currentlyBoosting = false
            self.maxspeed = self.old_maxspeed
         end

      end

      local boost = self.p.controller:boost()
      if boost > -2 and not self.currentlyBoosting and self.cooldown == 0 then
         local asize = self.p.att["size"]
         self.p.gs.factory:createExplosion(self.p.trans.x,self.p.trans.y,asize*2,20,asize*1.5,15,asize,10)
         self.p.gs.cammgr:shake(0.9,7)
         self.currentlyBoosting = true
         self.boostingTime = 10
         self.cooldown = 60
         self.maxspeed = self.old_maxspeed*1.5
         local rot = self.p.trans.r + boost*math.pi/2
         self:applyLinearImpulse(math.cos(rot)*16000,math.sin(rot)*16000)
      end
      
      
      self.p.trans.r = self.p.trans.r + (self.turnmomentum * self.turnspeed)
      local moveForce = self.p.controller:getAcceleration()
      --local moveForce = self.p.controller.moveDir.acc
      if moveForce > 0 then 
         self.body:setLinearDamping(self.ldamping)
         self.body:applyForce(math.cos(self.p.trans.r) * moveForce*self.force, math.sin(self.p.trans.r) * moveForce*self.force)
         --if(vector.len(self.body:getLinearVelocity()) > self.maxspeed) then
          --  local nx,ny = vector.normalize(self.body:getLinearVelocity())
           -- self.body:setLinearVelocity(nx*self.maxspeed,ny*self.maxspeed)
         --end
      end
   end
         if(vector.len(self.body:getLinearVelocity()) > self.maxspeed) then
            local nx,ny = vector.normalize(self.body:getLinearVelocity())
            self.body:setLinearVelocity(nx*self.maxspeed,ny*self.maxspeed)
         end
   
   -- update transformation
   self.p.trans.x, self.p.trans.y = self.body:getPosition()
end

function LovePhysics:applyForce(x,y)
   self.body:applyForce(x,y)
end

function LovePhysics:applyLinearImpulse(x,y)
   self.body:applyLinearImpulse(x,y)
end

function LovePhysics:setLinearDamping(ld)
   self.body:setLinearDamping(ld)
end


return LovePhysics
