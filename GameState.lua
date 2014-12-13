local class       = require 'middleclass'
local Factory     = require 'Factory'
local GameObject  = require 'GameObject'
local Collision   = require 'Collision'
local ResMgr      = require 'ResourceManager'

local GameState = class('GameState')

function GameState:initialize()

   self.hello = "yo gabba gabba"
   self.resmgr = ResMgr:new(self)
   self.factory = Factory:new(self,self.resmgr)
   self.collision = Collision:new(self)
   
   self.gameObjects = {}
   
   self:loadImages()
   self:addPlayer()
   --self:addMultiEnemy()
   self:addEnemy()
   self:addBackground()
end

function GameState:loadImages()
   self.resmgr:loadImg('img/spaceship.png',"spaceship")
   self.resmgr:loadImg('img/player.png',"shot")
end


function GameState:update()
   
   -- update
   --self.player:update()
   for i = #self.gameObjects, 1, -1 do
      if self.gameObjects[i].isAlive then
         self.gameObjects[i]:update()
      else
         self:destroy(i)
      end
   end
   
   --collision
   for i = 1, #self.gameObjects,1 do
      local go1 = self.gameObjects[i]
      if go1.collider ~= nil then
         for j = i+1,#self.gameObjects,1 do
            local go2 = self.gameObjects[j]
            if go2.collider ~= nil then
               if self.collision:collides(go1,go2) then
                  --print("COLLISION!!!!!! " .. love.timer.getTime())
               end
            end
         end
      end
   end
   -- post-update
end

function GameState:destroy(index)
   table.remove(self.gameObjects,index)
end

function GameState:draw()
   for i = #self.gameObjects, 1, -1 do
      self.gameObjects[i]:draw()
   end
end


function GameState:addPlayer()
   --self.player = self.factory:createPlayer(20,20,0)
   table.insert(self.gameObjects,self.factory:createPlayer(20,20,0))
end


function GameState:addMultiEnemy()
   for i = 0, 100 do
      table.insert(self.gameObjects,self.factory:createRandomEnemy())
   end
end

function GameState:addEnemy()
   table.insert(self.gameObjects,self.factory:createEnemy(800,600,0))
end

function GameState:addBackground()
   --table.insert(self.gameObjects,self.factory:createPlayer(20,20,0))
end



return GameState
