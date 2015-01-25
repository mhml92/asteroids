local class       = require 'middleclass'
local Exhaust = class('Exhaust')

-- relativ x, 
-- relativ y, 
-- img, 
-- buf, 
-- emissionrate, 
-- particle life time
-- spread
function Exhaust:initialize(rx,ry,img,buf,er,plt,spread)
   self.ps = love.graphics.newParticleSystem(img,buf)
   self.rx = rx
   self.ry = ry
   self.ps:setEmissionRate(er)
   self.ps:setSizes(0.04)
   self.ps:setParticleLifetime(plt-(plt/10),plt)
   self.ps:setSpread(spread)
   self.ps:pause()
end

function Exhaust:getType()
   return "Effect"
end   

function Exhaust:update(p)
   self.ps:setSpeed(p.physics.force*p.physics.mass*0.8,p.physics.force*p.physics.mass)

   
   self.ps:moveTo(
      p.trans.x+(-15*math.cos(p.trans.r)), 
      p.trans.y+(-15*math.sin(p.trans.r)) )
   
      self.ps:setDirection(p.trans.r-math.pi)
   if math.abs(p.controller.moveDir.x)+ math.abs(p.controller.moveDir.y) ~= 0 then
      self.ps:start()
   else
      self.ps:pause()
   end

   self.ps:update(1/60)
end

function Exhaust:draw(p)
   
   love.graphics.draw( self.ps,0,0)
end
return Exhaust
