local class = require 'middleclass/middleclass'
local vector = require 'hump/vector-light'
local AIUtil = class('AIUtil')

function AIUtil:initialize(gs)
   self.gs = gs
end

function AIUtil:getProjectiles()
   return self.gs.objmgr.projectiles
end

function AIUtil:getPlayers()
   return self.gs.objmgr.players
end

function AIUtil:getAsteroids()
   return self.gs.objmgr.astroids
end
return AIUtil
