local class       = require 'middleclass'

local ObjectManager = class('ObejctManager')

function ObjectManager:initialize(gs)
   self.gs = gs
   self.gameObjects = {}
   self.players = {}
   self.astroids = {}
   self.projectiles = {}
end

function ObjectManager:clear()
   self.gameObjects = {}
   self.players = {}
   self.astroids = {}
   self.projectiles = {}
end
function ObjectManager:updateAll()
   for i = #self.gameObjects, 1, -1 do
      if self.gameObjects[i].att["alive"] then
         self.gameObjects[i]:update()
      else
         if self.gameObjects[i].exit ~= nil then
            self.gameObjects[i].exit:update(self.gameObjects[i])
         end
         self:destroy(i)
      end
   end
end 

function ObjectManager:drawAll() 
   --sort draw order
   table.sort(self.gameObjects,function(a,b)return a.att["layer"]<b.att["layer"] end)
   -- draw dat shjjjiiiaaat
   for k,v in pairs(self.gameObjects) do
      v:draw()
   end
end

function ObjectManager:insert(o)
  
   if o.att["type"] == "projectile" then
      table.insert(self.projectiles,o)
   end

   if o.att["type"] == "player"  then
      table.insert(self.players,o)
   end
  
   if o.att["type"] == "astroid" then
      table.insert(self.astroids,o)
   end
  
   table.insert(self.gameObjects,o) 
end

function ObjectManager:destroy(i)
   if self.gameObjects[i].att["type"] == "projectile" then
      for j = #self.projectiles, 1,-1 do
         if self.projectiles[j].id == self.gameObjects[i].id then
            table.remove(self.projectiles,j)
         end
      end
   end
   
   if self.gameObjects[i].att["type"] == "astroid" then
      for j = #self.astroids, 1,-1 do
         if self.astroids[j].id == self.gameObjects[i].id then
            table.remove(self.astroids,j)
         end
      end
   end
   
   if self.gameObjects[i].att["type"] == "player" then
      for j = #self.players, 1,-1 do
         if self.players[j].id == self.gameObjects[i].id then
            table.remove(self.players,j)
         end
      end
   end
   

   if self.gameObjects[i].physics ~= nil then
      if self.gameObjects[i].physics.body ~= nil then
         --self.gameObjects[i].physics.fixture:destroy()
         --self.gameObjects[i].physics.shape:destroy()
         self.gameObjects[i].physics.body:destroy()
      end
   end

   table.remove(self.gameObjects,i)
end

function ObjectManager:beginContact(a,b,coll)
   local o1, o2
   o1 = a:getUserData()
   o2 = b:getUserData()
   o1.collision:handle(o2,coll)
   o2.collision:handle(o1,coll)
end

function ObjectManager:endContact(a,b,coll)
end

function ObjectManager:preSolve(a,b,coll)
end

function ObjectManager:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

return ObjectManager
