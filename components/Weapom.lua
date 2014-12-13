local class = require 'middleclass'
local Weapon = class('Weapon')

function Weapon:initialize()

end

function Weapon:getType()
   return 'Weapon'
end

function Weapon:update(p)
   local t = {}
   t.r = 0
   if p.controller.shooting then
      local mx = 0
      local my = 0

      if math.sqrt(p.controller.shootDir.x^2 + p.controller.shootDir.y^2) ~= 0 then 
         t.r = math.atan2(p.controller.shootDir.y,p.controller.shootDir.x)
      end
      t.x = p.trans.x-- + 25 * math.cos(t.r)
      t.y = p.trans.y-- + 25 * math.sin(t.r)
      for i = 1,1,1 do
         local s = p.gs.factory:createShot(t.x,t.y,t.r+(math.random()-0.5)*0.5)
         table.insert(p.gs.gameObjects,s)
      end
   end
end
return Weapon
