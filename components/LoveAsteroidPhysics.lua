local class = require 'middleclass/middleclass'
local LoveAsteroidPhysics = class('LoveAsteroidPhysics')

function LoveAsteroidPhysics:initialize(p,mass,speed,radius,restitution)

   self.p = p
   self.mass = mass
   self.speed = speed
   self.radius = radius
   self.restitution = restitution

   self.body = love.physics.newBody(p.gs.world,p.trans.x,p.trans.y,"dynamic") 
   self.shape = love.physics.newCircleShape(self.radius)
   self.fixture = love.physics.newFixture(self.body,self.shape)
   self.fixture:setUserData(self.p)
   self.body:resetMassData()
   self.body:setMass(self.mass)
   self.body:setAngularVelocity(math.random()*math.pi)
   local x,y = math.cos(p.trans.r),math.sin(p.trans.r)
   self.body:applyLinearImpulse(x*speed,y*speed)
   self.fixture:setRestitution(restitution)
   
end

function LoveAsteroidPhysics:getType()
   return 'Physics'
end

function LoveAsteroidPhysics:update()
   -- update transformation
   self.p.trans.r = self.body:getAngle()
   self.p.trans.x, self.p.trans.y = self.body:getPosition()
   
end

function LoveAsteroidPhysics:getSpeed()
   local vx,vy = self.body:getLinearVelocity()
   return math.sqrt(vx^2+vy^2)
end


function LoveAsteroidPhysics:applyForce(x,y)
   self.body:applyForce(x,y)
end

function LoveAsteroidPhysics:applyLinearImpulse(x,y)
   self.body:applyLinearImpulse(x,y)
end

return LoveAsteroidPhysics
