local class = require 'middleclass'
local LoveProjectilePhysics = class('LoveProjectilePhysics')

function LoveProjectilePhysics:initialize(p,speed,radius)

   self.p = p
   self.speed = speed
   self.radius = radius

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"kinematic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)
   self.body:setBullet(true)
   self.fixture:setSensor(true)
end

function LoveProjectilePhysics:getType()
   return 'Physics'
end

function LoveProjectilePhysics:update(p)
  -- local p = self.p
   
   if p.controller ~= nil then
      if p.controller.moveDir.x ~= 0 or p.controller.moveDir.y ~= 0 then 
         
         md = p.controller.moveDir
         local x,y = self.body:getPosition()
         self.body:setX(x+md.x*self.speed)
         self.body:setY(y+md.y*self.speed)

      end
   end
   
   -- update transformation
   p.trans.x, p.trans.y = self.body:getPosition()
   
end

function LoveProjectilePhysics:applyForce(x,y)
   self.body:applyForce(x,y)
end

function LoveProjectilePhysics:applyLinearImpulse(x,y)
   self.body:applyLinearImpulse(x,y)
end

return LoveProjectilePhysics
