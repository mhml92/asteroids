local class = require 'middleclass/middleclass'

local ShotController = class('ShotController')


function ShotController:initialize(r)
   self.moveDir = self:getMoveDir(r)
end

function ShotController:getType()
   return 'Controller'
end

function ShotController:update() 
end


function ShotController:getMoveDir(r)
   local dir = {}
   dir.x = math.cos(r)
   dir.y = math.sin(r)
   return dir  
end
return ShotController
