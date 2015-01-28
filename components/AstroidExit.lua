
local class = require 'middleclass'
local AstroidExit = class('ShotExit')
function AstroidExit:initialize(level)
   self.level = level;

end

function AstroidExit:update(p) 
   local r = p.trans.r+(((math.random()*2)-1)*math.pi/2)
   local health = p.att["startHealth"]
   if self.level > 1 then
     
      local unit,unith1,unith3toR,posxA,posyA,posxB,posyB,rot,rotA,rotB,nsize,nlevel
      toR = {}
      unit = {}
      unith1 = {}
      unith3 = {}
      toR.x,toR.y = p.physics.body:getLinearVelocity()
      rot = math.atan2(toR.y,toR.x)
      unit.x = math.cos(rot)
      unit.y = math.sin(rot)
      
      unith1.x = -1*unit.y
      unith1.y = unit.x
      
      unith3.x = unit.y
      unith3.y = -1*unit.x

      posxA = p.trans.x+unith1.x*(((3/4)*p.att["size"])/2) 
      posyA = p.trans.y+unith1.y*(((3/4)*p.att["size"])/2)
      rotA = (rot+math.pi/8)%(2*math.pi) 
      
      posxB = p.trans.x+unith3.x*(((3/4)*p.att["size"]/2)) 
      posyB = p.trans.y+unith3.y*(((3/4)*p.att["size"]/2))
      rotB = (rot-math.pi/8)%(2*math.pi) 
      nsize = p.att["size"]-(p.att["size"]/4)
      nlevel = self.level-1
      p.gs.factory:createAstroid(posxA,posyA,rotA,nsize,health,nlevel)
      p.gs.factory:createAstroid(posxB,posyB,rotB,nsize,health,nlevel)
      
      --[[
      for i = 1, 2 do
         local posx,posy,rot,nsize,nlevel
         posx = p.trans.x+((2*math.random())-1)*(p.att["size"]/2) 
         posy = p.trans.y+((2*math.random())-1)*(p.att["size"]/2)
         rot = (p.trans.r+(((math.random()*2)-1)*math.pi/8))%(2*math.pi) 
         nsize = p.att["size"]-(p.att["size"]/4)
         nlevel = self.level-1
         p.gs.factory:createAstroid(posx,posy,rot,nsize,health,nlevel)
      end½
      ]]
   end
end

function AstroidExit:getType() 
   return 'Exit'
end
return AstroidExit
