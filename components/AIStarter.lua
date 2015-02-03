local class = require 'middleclass'

local AIStarter = class('AIStarter')


function AIStarter:initialize(p)
   self.p = p
	self.astroids = self.p.gs.objmgr.astroids
   self.players = self.p.gs.objmgr.players
   self.projectiles = self.p.gs.objmgr.projectiles
end


function AIStarter:getType()
   return 'Controller'
end

function AIStarter:update() 
   self.moveDir = self:getMoveDir()
   self.shootDir = self:getShootDir()
   self.shooting = self:isShooting()
end

function AIStarter:isShooting()
   -- is your spaceship shooting? 
   -- returns a boolean (true/false)
end

function AIStarter:getMoveDir()
   --A vector of length 1, where 1 is max speed
   --if the vector is > 1 is the speed max speed
   local dir = {}
   dir.x = 0
   dir.y = 0

   local nearest = {}
   nearest.v = nil
   nearest.x = 9999999
   nearest.y = 9999999
   for k,v in ipairs(self.astroids) do
      if nearest.v == nil then
         nearest.v = v
      end
      nearest = self:setNearest(nearest,v)
   end
   
   dir.x = self.p.trans:getX() - nearest.x
   dir.y = self.p.trans:getY() - nearest.y
   dir.len = math.sqrt(dir.x^2+dir.y^2)
   dir.x = (dir.x/(dir.len))
   dir.y = (dir.y/(dir.len))
   return dir  
end

function AIStarter:setNearest(n,v)
   local d1,d2,d3,d4,d5,t
   local w,h = love.graphics.getDimensions()
   t = v.trans
   local dists ={}

   d1 = {}
   d1.x = t:getX()
   d1.y = t:getY()
   d1.d = self:dist(d1.x,d1.y)
   table.insert(dists,d1) 
   d2 = {}
   d2.x = t:getX()-w
   d2.y = t:getY()
   d2.d = self:dist(d2.x,d2.y)
   table.insert(dists,d2) 
   d3 = {}
   d3.x = t:getX()+w
   d3.y = t:getY()
   d3.d = self:dist(d3.x,d3.y)
   table.insert(dists,d3) 
   d4 = {}
   d4.x = t:getX()
   d4.y = t:getY()-h
   d4.d = self:dist(d4.x,d4.y)
   table.insert(dists,d4) 
   d5 = {}
   d5.x = t:getX()
   d5.y = t:getY()+h
   d5.d = self:dist(d5.x,d5.y)
   table.insert(dists,d5) 

   table.sort(dists,function(a,b) return a.d < b.d end)

   if self:dist(n.x,n.y) > dists[1].d then
      n.v = v
      n.x = dists[1].x
      n.y = dists[1].y
   end
   return n
end


function AIStarter:dist(x,y)
   return math.sqrt((self.p.trans:getX()-x)^2 + (self.p.trans:getY()-y)^2)
end

function AIStarter:getShootDir()
   --A vector of any length (except 0) pointing in the shooting direction
   --a vector of length 0 will result in no shooting
   local dir = {}
   dir.x = 0
   dir.y = 0

   return dir  
end

return AIStarter
