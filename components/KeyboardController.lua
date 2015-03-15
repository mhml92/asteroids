local class = require 'middleclass/middleclass'

local KeyboardController = class('KeyboardController')

function KeyboardController:initialize(p)
   self.p = p
end

function KeyboardController:getType()
   return 'Controller'
end

function KeyboardController:update() 
   self.shooting = self:isShooting()
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
end

function KeyboardController:isShooting()
   if love.keyboard.isDown(" ") then
      return true
   end
end

function KeyboardController:getMoveDir()
   local dir = {}
   dir.x = 0.0
   dir.y = 0.0
   --move
   if love.keyboard.isDown("w")then
   --if love.keyboard.isDown("up")then
      dir.y = dir.y - 1
   end
   if love.keyboard.isDown("a")then
   --if love.keyboard.isDown("left")then
      dir.x = dir.x - 1
   end
   if love.keyboard.isDown("s")then
   --if love.keyboard.isDown("down")then
      dir.y = dir.y + 1
   end
   if love.keyboard.isDown("d")then
   --if love.keyboard.isDown("right")then
      dir.x = dir.x + 1
   end
   if dir.x ~= 0 or dir.y ~= 0 then
      local unit = math.sqrt((dir.x^2)+(dir.y^2))
      dir.x = dir.x/unit
      dir.y = dir.y/unit
   end
   return dir  
end

function KeyboardController:getShootDir()
   local dir = {}
   dir.x = 0.0
   dir.y = 0.0
   --move
   if love.keyboard.isDown("i")then
   --if love.keyboard.isDown("up")then
      dir.y = dir.y - 1
   end
   if love.keyboard.isDown("j")then
   --if love.keyboard.isDown("left")then
      dir.x = dir.x - 1
   end
   if love.keyboard.isDown("k")then
   --if love.keyboard.isDown("down")then
      dir.y = dir.y + 1
   end
   if love.keyboard.isDown("l")then
   --if love.keyboard.isDown("right")then
      dir.x = dir.x + 1
   end
   return dir  
end

return KeyboardController
