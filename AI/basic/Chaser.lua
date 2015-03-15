local class = require 'middleclass/middleclass'

local Chaser = class('Chaser')


function Chaser:initialize(p)
   self.p = p
   self.spaceDown = false
   self.shooting = false 
end

function Chaser:getType()
   return 'Controller'
end

function Chaser:update() 
   self.shooting = self:isShooting()
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
end

function Chaser:isShooting()
   return false
end

function Chaser:getMoveDir()
   local dir = {}
   dir.x,dir.y = 0,0
   if self.p.gs.objmgr.players[1] ~= nil then
      local nearest = nil
      for k,v in ipairs(self.p.gs.objmgr.players) do
         if nearest == nil then
            nearest = v
         else
            if self:dist(v) < self:dist(nearest) then
               nearest = v
            end
         end
      end
      local playerPos = nearest.trans--gameObjects[1].trans
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

function Chaser:dist(o)
   local dx,dy
   dx = self.p.trans.x - o.trans.x
   dy = self.p.trans.y - o.trans.y
   return math.sqrt(dx^2+dy^2)
end

function Chaser:getShootDir()
   local dir = {}
   dir.x = 0.0
   dir.y = 0.0
   return dir  
end

return Chaser
