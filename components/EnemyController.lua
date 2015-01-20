local class = require 'middleclass'

local EnemyController = class('EnemyController')


function EnemyController:initialize()
   self.spaceDown = false
   self.shooting = false 
end

function EnemyController:getType()
   return 'Controller'
end

function EnemyController:update(p) 
   self.shooting = self:isShooting()
   self.moveDir = self:getMoveDir(p)
   self.shootDir = self:getShootDir()
end

function EnemyController:isShooting()
   return false
end

function EnemyController:getMoveDir(p)
   local playerPos = p.gs.objmgr.players[1].trans--gameObjects[1].trans
   local myPos = p.trans
   local dir = {}
   dir.x = playerPos.x - myPos.x
   dir.y = playerPos.y - myPos.y
   if dir.x ~= 0 and dir.y ~= 0 then
      local unit = math.sqrt(dir.x^2+dir.y^2)
      dir.x = dir.x/unit
      dir.y = dir.y/unit
   end
   return dir  
end

function EnemyController:getShootDir()
   local dir = {}
   dir.x = 0.0
   dir.y = 0.0
   return dir  
end

return EnemyController
