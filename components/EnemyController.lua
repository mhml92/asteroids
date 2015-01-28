local class = require 'middleclass'

local EnemyController = class('EnemyController')


function EnemyController:initialize(p)
   self.p = p
   self.spaceDown = false
   self.shooting = false 
end

function EnemyController:getType()
   return 'Controller'
end

function EnemyController:update() 
   self.shooting = self:isShooting()
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
end

function EnemyController:isShooting()
   return false
end

function EnemyController:getMoveDir()
   local dir = {}
   dir.x,dir.y = 0,0
   if self.p.gs.objmgr.players[1] ~= nil then
      local playerPos = self.p.gs.objmgr.players[1].trans--gameObjects[1].trans
      local myPos = self.p.trans
      dir.x = playerPos.x - myPos.x
      dir.y = playerPos.y - myPos.y
      if dir.x ~= 0 and dir.y ~= 0 then
         local unit = math.sqrt(dir.x^2+dir.y^2)
         dir.x = dir.x/unit
         dir.y = dir.y/unit
      end
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
