local class = require 'middleclass/middleclass'

local GamePadController = class('GamePadController')


function GamePadController:initialize(p)
   self.p = p
   local joysticks = love.joystick.getJoysticks()
   self.j = joysticks[1]
   --[[
   for k,v in joysticks do
      print("LOLOLOLOL")   
      self.j = v
      --break
   end
   ]]
end


function GamePadController:getType()
   return 'Controller'
end

function GamePadController:update() 
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
   self.shooting = self:isShooting()
end

function GamePadController:isShooting()
   --if self.shootDir.x ~= 0 or self.shootDir.y ~= 0 then
      return self.j:isGamepadDown("rightshoulder");
   --end
end

function GamePadController:getMoveDir()
   local dir = {}
   dir.x = self.j:getGamepadAxis("leftx")
   dir.y = self.j:getGamepadAxis("lefty")
   return dir  
end

function GamePadController:getShootDir()
      print(self.j:getGamepadAxis("triggerright")) 
      print(self.j:getGamepadAxis("triggerleft")) 
   local dir = {}
   dir.x = self.j:getGamepadAxis("rightx")
   dir.y = self.j:getGamepadAxis("righty")
   return dir  
end

return GamePadController
