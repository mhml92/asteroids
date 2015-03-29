local class = require 'middleclass/middleclass'

local KeyboardController = class('KeyboardController')

function KeyboardController:initialize(p)
   self.p = p
end

function KeyboardController:getType()
   return 'Controller'
end

function KeyboardController:isShooting()
   if love.keyboard.isDown(" ") then
      return true
   end
end

function KeyboardController:getAcceleration()
   local acc = 0
   --move

   if love.keyboard.isDown("up")then
      acc = acc + 1
   end
   if love.keyboard.isDown("down")then
      acc = acc - 1
   end
   return acc
end

function KeyboardController:getTurn()
   local turn = 0
   if love.keyboard.isDown("left")then
      turn = turn - 1
   end
   if love.keyboard.isDown("right")then
      turn = turn + 1
   end
   return turn  
end

function KeyboardController:boost()
   if love.keyboard.isDown("b") then
      print("prut")
   end
end
--[[
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
]]
return KeyboardController
