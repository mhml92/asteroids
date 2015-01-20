local class = require 'middleclass'
local PlayerExit = class('ShotExit')
function PlayerExit:initialize()

end



function PlayerExit:update(p) 
   p.gs.factory:createHit(
   p.trans.x,
   p.trans.y,
   math.random()*2*math.pi,
   p.gs.resmgr:getImg("hit"), --sprite
   100, --size
   30 --time
   )
end

function PlayerExit:getType() 
   return 'Exit'
end
return PlayerExit



