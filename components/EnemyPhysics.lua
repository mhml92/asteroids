local class = require 'middleclass'
local EnemyPhysics = class('Physics')

function EnemyPhysics:initialize()

   self.friction = 0.999999
   self.maxspeed = 5
   self.vel = {}
   self.vel.x = 0
   self.vel.y = 0
   self.force = 0.01

end

function EnemyPhysics:getType()
   return 'Physics'
end

function EnemyPhysics:update(p)
   if math.sqrt(p.controller.moveDir.x^2 + p.controller.moveDir.y^2) ~= 0 then 
      --player.dir.x = p.controller.moveDir.x
      --player.dir.y = p.controller.moveDir.y
      p.trans.r = math.atan2(p.controller.moveDir.y,p.controller.moveDir.x)
   end
   --Grand theft unicycle controles
   --[[
   if math.sqrt(player.vel.x^2 + player.vel.y^2) ~= 0 then
      player.dir.x = player.vel.x
      player.dir.y = player.vel.y
   end
   if math.sqrt(controller.shoot.x^2 + controller.shoot.y^2) ~= 0 then 
      player.weapon.dir.x = controller.shoot.x
      player.weapon.dir.y = controller.shoot.y
      player.weapon.dir.r = math.atan2(player.weapon.dir.y,player.weapon.dir.x)-3*math.pi/2
   end
   ]]
   --update velocity
   self.vel.x = self.vel.x + (p.controller.moveDir.x * self.force)
   self.vel.y = self.vel.y + (p.controller.moveDir.y * self.force)
   
   --update friction
   self.vel.x = self.vel.x * self.friction
   self.vel.y = self.vel.y * self.friction
   
   
   if math.sqrt(self.vel.x^2 + self.vel.y^2) < 0.1 then
      self.vel.x = 0
      self.vel.y = 0
   elseif math.sqrt(self.vel.x^2 + self.vel.y^2) > self.maxspeed then
      magnetude = math.sqrt(self.vel.x^2 + self.vel.y^2)
      self.vel.x = self.maxspeed*self.vel.x/magnetude
      self.vel.y = self.maxspeed*self.vel.y/magnetude
   end
  
   -- update transformation
   p.trans.x = p.trans.x + self.vel.x
   p.trans.y = p.trans.y + self.vel.y
   
--[[   
   sw, sh = love.window.getDimensions()
   if self.x > sw then
      self.x = sw
   end
   
   if self.x < 0 then
      self.x = 0
   end
   if self.y < 0 then
      self.y = 0
   end

   if self.y > sh then
      self.y = sh
   end
   ]]
end

return EnemyPhysics
