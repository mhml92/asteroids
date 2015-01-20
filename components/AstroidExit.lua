
local class = require 'middleclass'
local AstroidExit = class('ShotExit')
function AstroidExit:initialize(level)
   self.level = level;

end

function AstroidExit:update(p) 
   local r = p.trans.r+(((math.random()*2)-1)*math.pi/2)
   local health = p.att["startHealth"]
   if self.level > 1 then
      for i = 1, 2 do
         p.gs.factory:createAstroid(
            p.trans.x,
            p.trans.y,
            r,
            p.att["size"]-(p.att["size"]/4),
            health,
            self.level-1)
      end
   end
end

function AstroidExit:getType() 
   return 'Exit'
end
return AstroidExit
