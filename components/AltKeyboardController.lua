local class = require 'middleclass/middleclass'

local AltKeyboardController = class('AltKeyboardController')


function AltKeyboardController:initialize(p)
   self.p = p
end


function AltKeyboardController:getType()
   return 'Controller'
end


function AltKeyboardController:isShooting()
	if love.keyboard.isDown(" ") then
		return true
	else
		return false
	end 
end

function AltKeyboardController:getAcceleration()

	if love.keyboard.isDown("up") then
		return 1
	else
		return 0
	end 
end

function AltKeyboardController:getTurn()
   local turn = 0
	
	if love.keyboard.isDown("left") then
		turn = turn - 1
	end

	if love.keyboard.isDown("right") then
		turn = turn + 1
	end

   return turn  
end

function AltKeyboardController:boost()
	if love.keyboard.isDown("b") then
		return 0
	else
		return -2
	end
end

--[[
function AltKeyboardController:getMoveDir()
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
function AltKeyboardController:update() 
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
   self.shooting = self:isShooting()
end

function AltKeyboardController:isShooting()
   --if self.shootDir.x ~= 0 or self.shootDir.y ~= 0 then
      return self.j:isGamepadDown("rightshoulder");
   --end
end

function AltKeyboardController:getMoveDir()
   local dir = {}
   dir.turn = self.j:getGamepadAxis("rightx")
   dir.acc = -self.j:getGamepadAxis("lefty")

   return dir  
end

function AltKeyboardController:getShootDir()
   local dir = {}
   dir.x = math.cos(self.p.trans.r)--self.j:getGamepadAxis("rightx")
   dir.y = math.sin(self.p.trans.r)--self.j:getGamepadAxis("righty")
   return dir  
end
]]
return AltKeyboardController
