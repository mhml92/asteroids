local class = require 'middleclass/middleclass'

local vector = require 'hump/vector-light'
local PlanetGravity = class('PlanetGravity')

function PlanetGravity:initialize(p)
   self.p = p
   self.planets = self.p.gs.objmgr.planets
end

function PlanetGravity:getType() 
   return 'PlanetGravity'
end

function PlanetGravity:update()
   local i,nearest = self:getNearestPalnetIndex()
   if i ~= nil then
      local plnt = self.p.gs.objmgr.planets[i]         
      if nearest  < plnt.att["gravityradius"] then
         local t = self.p.trans
         local vx,vy = plnt.trans.x-t.x,plnt.trans.y-t.y
         local currentG = plnt.att["gravity"]/math.log(nearest)
         local vx,vy = vector.normalize(vx,vy)
         self.p.physics:applyForce(vx*currentG,vy*currentG)
       end
   end
end

function PlanetGravity:getNearestPalnetIndex()
   local nearest,index = 1/0,nil --1/0 = inf

   local t = self.p.trans
   for i = #self.planets,1,-1 do
      local plnt = self.planets[i]
      local dist = vector.dist(t.x,t.y,plnt.trans.x,plnt.trans.y)-plnt.att["size"]
      if dist < nearest  then
         nearest = dist
         index = i
      end
   end
   return index,nearest
end

return PlanetGravity
