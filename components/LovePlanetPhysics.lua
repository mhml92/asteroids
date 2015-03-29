local class = require 'middleclass/middleclass'
local LovePlanetPhysics = class('LovePlanetPhysics')

function LovePlanetPhysics:initialize(p,mass,speed,radius,restitution)

   self.p = p
   self.mass = mass
   self.speed = speed
   self.radius = radius
   self.restitution = restitution

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"static") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)
   self.body:resetMassData()
   self.body:setMass(self.mass)
   self.body:setFixedRotation(true)
   --local x,y = math.cos(p.trans.r),math.sin(p.trans.r)
   --self.body:applyLinearImpulse(x*speed,y*speed)
   self.fixture:setRestitution(restitution)
   --self.fixture:setFriction(99991)
   
end

function LovePlanetPhysics:getType()
   return 'Physics'
end

function LovePlanetPhysics:update(p)
  -- local p = self.p
  --[[ 
   if p.controller ~= nil then
      if p.controller.moveDir.x ~= 0 or p.controller.moveDir.y ~= 0 then 
         
         md = p.controller.moveDir
         local x,y = self.body:getPosition()
         self.body:setX(x+md.x*self.speed)
         self.body:setY(y+md.y*self.speed)

      end
   end
   ]]
   -- update transformation
   --p.trans.r = self.body:getAngle()
   --p.trans.x, p.trans.y = self.body:getPosition()
   
end

function LovePlanetPhysics:getSpeed()
   local vx,vy = self.body:getLinearVelocity()
   return math.sqrt(vx^2+vy^2)
end


function LovePlanetPhysics:applyForce(x,y)
   self.body:applyForce(x,y)
end

function LovePlanetPhysics:applyLinearImpulse(x,y)
   self.body:applyLinearImpulse(x,y)
end

return LovePlanetPhysics
