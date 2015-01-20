local class = require 'middleclass' 

local CollisionSystem = class("CollisionSystem")

function CollisionSystem:initialize(p, collider)
   self.p = p
   self.collider = collider
end

function CollisionSystem:getType()
   return 'CollisionSystem'
end

function CollisionSystem:handleCollision(co)
   local a,b
   if self.p.id == co.o1.id then
      a = co.o1
      b = co.o2
   else
      b = co.o1
      a = co.o2
   end
  
   if a.att["type"] == "astroid" and b.att["type"] == a.att["type"] then
      return   
   end


   if a.att["type"]== "projectile" then
      if b.att["type"] == a.att["type"] then
         return
      else
         a.att["alive"] = false
         a.att["hit"] = true
      end
   end

   if a.att["health"] ~= nil then
      if b.att["damage"] ~= nil then
        self:damage(b.att["damage"])
      end
   end
   
end

function CollisionSystem:handleImpact(co)
   local dv = co:getDeltaVel(self.p.id)
   self.p.physics:applyForce(dv.x,dv.y)
 
   local o1,o2
   if self.p.id == co.o1.id then
      o1 = co.o1
      o2 = co.o2
   else
      o2 = co.o1
      o1 = co.o2
   end

   -- fix position
   local R = o1.colsys.collider.r + o2.colsys.collider.r
   local unit = {}
   if o1.physics.mass < o2.physics.mass then
      unit.x = o1.trans.x - o2.trans.x
      unit.y = o1.trans.y - o2.trans.y
      unit.len = math.sqrt(unit.x^2 + unit.y^2)
      unit.x = unit.x/unit.len
      unit.y = unit.y/unit.len
      o1.trans.x = o2.trans.x + (R*unit.x)
      o1.trans.y = o2.trans.y + (R*unit.y)
   else
      unit.x = o2.trans.x - o1.trans.x
      unit.y = o2.trans.y - o1.trans.y
      unit.len = math.sqrt(unit.x^2 + unit.y^2)
      unit.x = unit.x/unit.len
      unit.y = unit.y/unit.len
      o2.trans.x = o1.trans.x + (R*unit.x)
      o2.trans.y = o1.trans.y + (R*unit.y)
   end
end

function CollisionSystem:damage(damage)
   self.p.att["health"] = self.p.att["health"] - damage
   if self.p.att["health"] <= 0 then
      self.p.att["alive"] = false
   end
end

return CollisionSystem
