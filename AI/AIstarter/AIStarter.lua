local class    = require 'middleclass/middleclass'
local vector = require 'hump/vector-light'
local AIUtil   = require 'AI/AIUtil'

local AIStarter = class('AIStarter')

function AIStarter:initialize(p)
   self.p = p
   self.aiu = AIUtil:new(p.gs)
	self.astroids = self.aiu:getAsteroids()
   self.players = self.aiu:getPlayers()
   self.projectiles = self.aiu:getProjectiles()
end

function AIStarter:getType()
   return 'Controller'
end

function AIStarter:isShooting()
   -- is your spaceship shooting? 
   -- returns a boolean (true/false)
   return false
end

function AIStarter:getAcceleration()
   return 1
end

function AIStarter:getTurn()
   local pos = self.p.trans
   local pl = self.aiu:getPlayers()[1].trans
   if vector.cross(pl.x-pos.x,pl.y-pos.y,math.cos(pos.r),math.sin(pos.r)) > 0 then
      return -1
   else
      return 1
   end
end

return AIStarter
