local class       = require 'middleclass'

local CollisionObject   = require 'CollisionSystem/CollisionObject'
local ObjectManager = class('ObejctManager')

function ObjectManager:initialize(gs)
   self.gs = gs
   self.gameObjects = {}
   self.players = {}
   self.astroids = {}
end

function ObjectManager:clear()
   self.gameObjects = {}
   self.players = {}
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

function ObjectManager:checkCollisions()
   for i = #self.gameObjects,1,-1 do
      local go1 = self.gameObjects[i]
      --has collider and is alive
      if go1.colsys ~= nil and go1.att["alive"] then
         for j = i-1, 1,-1 do 
            go2 = self.gameObjects[j]
            --has collider and is alive
            if go2.colsys ~= nil and go2.att["alive"] then
               
               if not self:hasOwnership(go1,go2) then
                  --if same type
                  if gs.colutil:collides(go1,go2) then 
                     -- colutil:collides should maybe return the collisionobject

                     local co = CollisionObject:new(go1, go2)
                     go1.colsys:handleCollision(co)
                     go2.colsys:handleCollision(co)
                  end
               end
            end
         end
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


function ObjectManager:hasOwnership(go1,go2)
   if go1.att["owner"] == go2.id or go2.att["owner"] == go1.id then
      return true
   else
      return false
   end
end

function ObjectManager:insert(o)
   
   if o.att["type"] == "player"  then
      table.insert(self.players,o)
   end
  
   if o.att["type"] == "astroid" then
      table.insert(self.astroids,o)
   end
  
   table.insert(self.gameObjects,o) 
end

function ObjectManager:destroy(i)
   
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
   table.remove(self.gameObjects,i)
end

return ObjectManager
