local class = require 'middleclass/middleclass'
local ShotExit = class('ShotExit')
function ShotExit:initialize()

end



function ShotExit:update(p) 
   if p.att["hit"] then
      p.gs.factory:createHit(
      p.trans.x,
      p.trans.y,
      math.random()*2*math.pi,
      p.gs.resmgr:getImg("hit"), --sprite
      20, --size
      5 --time
      )
   end
end

function ShotExit:getType() 
   return 'Exit'
end
return ShotExit
