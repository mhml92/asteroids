local class = require 'middleclass'
local Weapon = class('Weapon')

function Weapon:initialize(coolDown,force)
   self.coolDown = coolDown
   self.force = force
   self.temp = 0
end

function Weapon:getType()
   return 'Weapon'
end

function Weapon:update(p)
   local t = {}
   t.r = 0
   if self.temp > 0 then 
      self.temp = self.temp -1 
   end
   if p.controller.shooting and self.temp == 0 then
      self.temp = self.coolDown 
      local mx = 0
      local my = 0

      if math.sqrt(p.controller.shootDir.x^2 + p.controller.shootDir.y^2) ~= 0 then 
         t.len = math.sqrt(p.controller.shootDir.x^2 + p.controller.shootDir.y^2)
         t.r = math.atan2(p.controller.shootDir.y,p.controller.shootDir.x)
         t.ix = p.controller.shootDir.x *-1
         t.ix = t.ix/t.len
         t.iy = p.controller.shootDir.y *-1
         t.iy = t.iy/t.len
         t.x = p.trans.x-- + 25 * math.cos(t.r)
         t.y = p.trans.y-- + 25 * math.sin(t.r)
         
         --for i = 1,1,1 do
         p.gs.factory:createProjectile(
            t.x,
            t.y,
            t.r,
            1, -- damage
            p.gs.resmgr:getImg("fire"), --sprite
            20, -- size
            p.id) -- owner
         --end o
         p.physics:applyLinearImpulse(self.force*t.ix,self.force*t.iy)
      end
   end
end
return Weapon
