local class = require 'middleclass'

local AIStarter = class('AIStarter')


function AIStarter:initialize(p)
   self.p = p
	self.astroids = self.p.gs.objmgr.astroids
   self.players = self.p.gs.objmgr.players
   self.projectiles = self.p.gs.objmgr.projectiles
end


function AIStarter:getType()
   return 'Controller'
end

function AIStarter:update() 
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
   self.shooting = self:isShooting()
end

function AIStarter:isShooting()
   -- is your spaceship shooting? 
   -- returns a boolean (true/false)
end

function AIStarter:getMoveDir()
   --A vector of length 1, where 1 is max speed
   --if the vector is > 1 is the speed max speed
   local dir = {}
   dir.x = 0
   dir.y = 0

   return dir  
end

function AIStarter:getShootDir()
   --A vector of any length (except 0) pointing in the shooting direction
   --a vector of length 0 will result in no shooting
   local dir = {}
   dir.x = 0
   dir.y = 0

   return dir  
end

return AIStarter
