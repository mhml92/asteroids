local class = require 'middleclass/middleclass'
local vector = require 'hump/vector-light'
local PlanetShadow = class('PlanetShadow')

function PlanetShadow:initialize(p,img)
   self.p = p
   self.img = img
   --self.x = 0
   --self.y = 0
   self.radius = 0
end

function PlanetShadow:getType()
   return "Effect"
end   

function PlanetShadow:update(p)
end

function PlanetShadow:draw()
   local players = self.p.gs.objmgr.players
   local asteroids = self.p.gs.objmgr.astroids
   self:drawList(players)
   self:drawList(asteroids)
end

function PlanetShadow:drawList(objList)
   self.x, self.y, self.radius = self.p.trans.x, self.p.trans.y, self.p.att["size"] 
   for i = #objList,1,-1 do
      local ot = objList[i].trans
      local dist = vector.dist(self.x,self.y,ot.x,ot.y)
      local psize = self.p.att["size"]
      deltaDist = (dist-psize)-objList[i].att["size"]/2 
      if deltaDist < 175 then
         local scale = objList[i].graphics.img:getWidth()*2/(self.img:getWidth()) 
         local dx,dy = ((ot.x)-self.x),((ot.y)-self.y)        
         dx,dy = vector.normalize(dx,dy)
          
         dx,dy = dx*psize,dy*psize
         love.graphics.draw( self.img,self.x+dx,self.y+dy,vector.angleTo(dx,dy)+(math.pi/2),scale,scale,self.img:getWidth()/2,self.img:getHeight()/2)
      end
   end

end


return PlanetShadow
