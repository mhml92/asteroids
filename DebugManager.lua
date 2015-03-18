local class = require 'middleclass/middleclass'

local DebugManager = class('DebugManager')

function DebugManager:initialize(gs)
   self.gs = gs
end

function DebugManager:update(dt)
   if love.keyboard.isDown("r") then
      self.gs:startGame()
   end
   if love.keyboard.isDown("a") then
      self.gs:addAstroids(1)
   end
end

return DebugManager
