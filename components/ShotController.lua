local class = require 'middleclass'

local ShotController = class('ShotController')


function ShotController:initialize()
end

function ShotController:getType()
   return 'Controller'
end

function ShotController:update(p) 
   self.moveDir = self:getMoveDir(p)
end

function ShotController:getMoveDir(p)
   local dir = {}
   dir.x = math.cos(p.trans.r) 
   dir.y = math.sin(p.trans.r) 
   return dir  
end

return ShotController
