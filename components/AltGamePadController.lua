local class = require 'middleclass'

local AltGamePadController = class('AltGamePadController')


function AltGamePadController:initialize(p)
   self.p = p
   local joysticks = love.joystick.getJoysticks()
   self.j = joysticks[1]
end


function AltGamePadController:getType()
   return 'Controller'
end

function AltGamePadController:update() 
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
   self.shooting = self:isShooting()
end

function AltGamePadController:isShooting()
   --if self.shootDir.x ~= 0 or self.shootDir.y ~= 0 then
      return self.j:isGamepadDown("rightshoulder");
   --end
end

function AltGamePadController:getMoveDir()
   local dir = {}
   dir.turn = self.j:getGamepadAxis("rightx")
   dir.acc = -self.j:getGamepadAxis("lefty")

   return dir  
end

function AltGamePadController:getShootDir()
   local dir = {}
   dir.x = math.cos(self.p.trans.r)--self.j:getGamepadAxis("rightx")
   dir.y = math.sin(self.p.trans.r)--self.j:getGamepadAxis("righty")
   return dir  
end

return AltGamePadController
