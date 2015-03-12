local class = require 'middleclass'
local PlayerExit = class('ShotExit')
function PlayerExit:initialize(p)
   self.p = p
end



function PlayerExit:update(p) 
    
   local psize = 80
   self.p.gs.factory:createExplosion(p.trans.x,p.trans.y,psize*1.5,15,psize*1.25,10,psize,5)
   --[[p.gs.factory:createHit(
   p.trans.x,
   p.trans.y,
   math.random()*2*math.pi,
   p.gs.resmgr:getImg("hit"), --sprite
   100, --size
   30 --time
   )
   ]]
end

function PlayerExit:getType() 
   return 'Exit'
end
return PlayerExit



