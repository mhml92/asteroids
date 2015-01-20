local class             = require 'middleclass'
local Factory           = require 'Factory'
local GameObject        = require 'GameObject'
local CollisionUtil     = require 'CollisionSystem/CollisionUtil'
local ResMgr            = require 'ResourceManager'
local ObjectManager     = require 'ObjectManager'
local GameState = class('GameState')

function GameState:initialize()

   self.hello = "yo gabba gabba"
   self.resmgr = ResMgr:new(self)
   self.objmgr = ObjectManager:new(self)
   self.factory = Factory:new(self,self.resmgr)
   self.colutil = CollisionUtil:new(self)
   
   self:loadImages()
   --self:addBackground()
   self:startGame()
   
   -- TEST

   local joysticks = love.joystick.getJoysticks()
   self.j = joysticks[1]

end

function GameState:loadImages()
   self.resmgr:loadImg('img/spaceship.png',"spaceship")
   self.resmgr:loadImg('img/player.png',"booger")
   self.resmgr:loadImg('img/fire.png',"fire")
   self.resmgr:loadImg('img/saft.png',"saft")
   self.resmgr:loadImg('img/fighter.png',"fighter")
   self.resmgr:loadImg('img/asteroid.png','astroid1')
   self.resmgr:loadImg('img/asteroid1.png','astroid2')
   self.resmgr:loadImg('img/bg.png',"bg")
   self.resmgr:loadImg('img/stjerner.png','stjerner')
   --self.resmgr:loadImg('img/monster.png',"astroid")
   self.resmgr:loadImg('img/hit.png','hit')
end

function GameState:startGame()
   self.objmgr:clear()
   self:addPlayer()
   self:addPlayer()
   self:addPlayer()
   self:addPlayer()
   self:addPlayer()
   self:addPlayer()
   self:addPlayer()
   --self:addMultiEnemy(50)
   self:addAstroids(5)
end

function GameState:update()
  --[[ 
   if (#self.objmgr.players == 0 or #self.objmgr.astroids == 0)  and self.j:isGamepadDown("start") then
      self:startGame()
   end
]]
   -- update
   self.objmgr:updateAll()
   
   --collision
   self.objmgr:checkCollisions()
end


function GameState:draw()
   love.graphics.draw(self.resmgr:getImg('stjerner'),0,0,0,1,1)
   self.objmgr:drawAll()
end


function GameState:addPlayer()
   --self.player = self.factory:createPlayer(20,20,0)
   local w,h = love.graphics.getDimensions()
   self.factory:createPlayer(math.random()*w,math.random()*h,0)
end

function GameState:addAstroids(n)
   for i = 1, n do
      local x,y,r,level,size
      local w, h = love.graphics.getDimensions()
      x = math.random()*w
      y = math.random()*h
      r = math.random()*2*math.pi
      size = 100
      level = 6
      self.factory:createAstroid(x,y,r,size,1,level)
   end
end


function GameState:addMultiEnemy(n)
   local w, h = self.w,self.h--love.graphics.getDimensions( )
   for i = 1, n do
      self.factory:createEnemy(math.random()*w,math.random()*h,0,40)
   end
end

function GameState:addEnemy()
   self.factory:createEnemy(800,600,0,40)
end

function GameState:addBackground()
   --table.insert(self.gameObjects,self.factory:createPlayer(20,20,0))
end


return GameState
