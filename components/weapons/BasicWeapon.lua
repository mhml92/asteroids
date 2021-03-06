local class = require 'middleclass/middleclass'
local BasicWeapon = class('BasicWeapon')

function BasicWeapon:initialize(p,coolDown,force)
   self.p = p
   self.coolDown = coolDown
   self.force = force
   self.temp = 0
end

function BasicWeapon:getType()
   return 'Weapon'
end

function BasicWeapon:update()
   local t = {}
   t.r = 0
   if self.temp > 0 then 
      self.temp = self.temp -1 
   end
   if self.p.controller:isShooting() and self.temp == 0 then
      
      self.p.gs.cammgr:shake(0.6,3)
      self.temp = self.coolDown 
         t = self.p.trans
         self.p.gs.factory:createProjectile(
            t.x,
            t.y,
            t.r,
            10, -- damage
            self.p.gs.resmgr:getImg("fire"), --sprite
            20, -- size
            self.p.id) -- owner
   end
end
return BasicWeapon
