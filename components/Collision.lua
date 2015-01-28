local class = require 'middleclass'
local Collision = class('Collision')

function Collision:initialize(p)
   self.p = p
end

function Collision:getType()
   return 'Collision'
end

function Collision:handle(o,coll)
   --parent type
   local pt = self.p.att["type"]
   --object type
   local ot = o.att["type"]
   
   if pt == "projectile" then
      
      if not self:hasOwnership(o) then
         self.p.att["alive"] = false
         self.p.att["hit"] = true
      end

   elseif pt == "astroid" then
      
      if ot ~= "astroid" then
        self:takeDamage(o)
      end

   elseif pt == "player" then
   
      if ot == "projectile" and not self:hasOwnership(o) then
         self:takeDamage(o)
      end

      if ot == "astroid" then
         self:takeDamage(o)
      end

   elseif pt == "hunter" then
      if ot == "projectile" and not self:hasOwnership(o) then
         self:takeDamage(o)
      end
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

