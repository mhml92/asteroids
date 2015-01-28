local class = require 'middleclass'
local Collision = class('Collision')

function Collision:initialize(p)
   self.p = p
end

function Collision:getType()
   return 'Collision'
end

function Collision:handle(o)
   --parent type
   local pt = self.p.att["type"]
   --object type
   local ot = o.att["type"]
   
   if pt == "projectile" then
      if not self:hasOwnership(o) then
         self.p.att["alive"] = false
         self.p.att["hit"] = true
      end
      return
   end

   if o.att["damage"] ~= nil and self.p.att["health"] ~= nil then
      if ot == "astroid" and pt =="astroid" then
         return
      end
      if ot == "projectile" then
         if o.att["hit"] then
            return
         else
            o.att["hit"] = true
         end
      end
      self.p.att["health"] = self.p.att["health"] - o.att["damage"]
      self:stillAlive()
      return
   end
end

function Collision:stillAlive()
   print(self.p.att["health"])
   if self.p.att["health"] <= 0 then
      self.p.att["alive"] = false
   end
end

function Collision:hasOwnership(o)
   return (self.p.att["owner"] == o.id)
end

return Collision

