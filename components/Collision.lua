local class = require 'middleclass/middleclass'
local Collision = class('Collision')

function Collision:initialize(p)
   self.p = p
end

function Collision:getType()
   return 'Collision'
end

function Collision:handleBegin(o,coll)
   --parent type
   local pt = self.p.att["type"]
   --object type
   local ot = o.att["type"]
   
   
   if pt == "projectile" then
   --=========================================
   -- PROJECTILE
   --=========================================
      if not self:hasOwnership(o) and self.p.att["owner"] ~= o.att["owner"] then
         self.p.att["alive"] = false
         self.p.att["hit"] = true
      end

   elseif pt == "astroid" then
   --=========================================
   -- ASTEROID
   --=========================================
      
      if ot ~= "astroid" then
        self:takeDamage(o)
      end
      
   elseif pt == "player" then
   --=========================================
   -- PLAYER
   --=========================================
      if ot == "planet" then
         self.p.physics:setLinearDamping(o.att["friction"]) 
      end
      if ot == "projectile" and not self:hasOwnership(o) then
         self:takeDamage(o)
      end

      if ot == "astroid" then
         self:takeDamage(o)
      end
   elseif pt == "planet" then
   --==========================================
   -- PLANET
   --==========================================
      --notttting
   end
end

function Collision:handleEnd(o,coll)
   --parent type
   local pt = self.p.att["type"]
   --object type
   local ot = o.att["type"]
   
   
   if pt == "projectile" then
   --=========================================
   -- PROJECTILE
   --=========================================
   elseif pt == "astroid" then
   --=========================================
   -- ASTEROID
   --=========================================
   elseif pt == "player" then
   --=========================================
   -- PLAYER
   --=========================================
      if ot == "planet" then
         self.p.physics:setLinearDamping(0)
      end

   elseif pt == "planet" then
   --==========================================
   -- PLANET
   --==========================================
      --notttting
   end
end

function Collision:takeDamage(o)
   self.p.att["health"] = self.p.att["health"] - o.att["damage"]
   self:stillAlive()
end

function Collision:stillAlive()
   if self.p.att["health"] <= 0 then
      self.p.att["alive"] = false
   end
end

function Collision:hasOwnership(o)
   return (self.p.att["owner"] == o.id) or (o.att["owner"] == self.p.id)
end

return Collision

