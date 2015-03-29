local class = require 'middleclass/middleclass'

local DebugManager = class('DebugManager')

function DebugManager:initialize(gs)
   self.gs = gs
   self.zoom = 1
   self.zoomDelta = 0.05
end

function DebugManager:update(dt)
   if love.keyboard.isDown("r") then
      self.gs:startGame()
      self.zoom = 1
      self.gs.cammgr.cam:zoomTo(self.zoom)
   end
   if love.keyboard.isDown("a") then
      self.gs:addAstroids(1)
   end
   
   if love.keyboard.isDown("1") then
      self.zoom = 0.5
      self.gs.cammgr.cam:zoomTo(self.zoom)
   end
   
   if love.keyboard.isDown("2") then
      self.zoom = 1
      self.gs.cammgr.cam:zoomTo(self.zoom)
   end
   if love.keyboard.isDown("3") then
      self.zoom = 2
      self.gs.cammgr.cam:zoomTo(self.zoom)
   end

end

return DebugManager
