local class = require 'middleclass/middleclass'

local AltGamePadController = class('AltGamePadController')


function AltGamePadController:initialize(p)
   self.p = p
   local joysticks = love.joystick.getJoysticks()
   self.j = joysticks[1]
end


function AltGamePadController:getType()
   return 'Controller'
end


function AltGamePadController:isShooting()
   return self.j:isGamepadDown("rightshoulder");
end

function AltGamePadController:getAcceleration()
 
   local acc = 0
   acc = -self.j:getGamepadAxis("lefty")
   return acc
end

function AltGamePadController:getTurn()
   local turn = 0
   turn = self.j:getGamepadAxis("rightx")
   return turn  
end

function AltGamePadController:boost()
   if self.j:getGamepadAxis("triggerright") > 0 then
      return 0
   --elseif self.j:isGamepadDown("dpleft") then
   --   return -1
   --elseif self.j:isGamepadDown("dpright") then
    --  return 1
   else
      return -2
   end
end

--[[
function AltGamePadController:getMoveDir()
   local dir = {}
   dir.turn = 0.0
   dir.acc = 0.0
   --move

   if love.keyboard.isDown("up")then
      dir.acc = dir.acc + 1
   end
   if love.keyboard.isDown("down")then
      dir.acc = dir.acc - 1
   end
   if love.keyboard.isDown("left")then
      dir.turn = dir.turn - 1
   end
   if love.keyboard.isDown("right")then
      dir.turn = dir.turn + 1
   end
   return dir  
end
]]
--[[
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
]]
return AltGamePadController
