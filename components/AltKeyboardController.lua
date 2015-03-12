local class = require 'middleclass'

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

function KeyboardController:getShootDir()
   local dir = {}
   dir.x = math.cos(self.p.trans.r)--self.j:getGamepadAxis("rightx")
   dir.y = math.sin(self.p.trans.r)--self.j:getGamepadAxis("righty")
   return dir  
end

return KeyboardController
