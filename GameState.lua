local class             = require 'middleclass/middleclass'
local Factory           = require 'Factory'
local GameObject        = require 'GameObject'
local ResMgr            = require 'ResourceManager'
local ObjectManager     = require 'ObjectManager'

local GameState = class('GameState')


-- User Controllers
local AltGamePadController    = require 'components/AltGamePadController'
local GamePadController = require 'components/GamePadController'
local KeyboardController= require 'components/KeyboardController'
local AltKeyboardController= require 'components/AltKeyboardController'

-- AI
local VokronAI          = require 'AI/michael/VokronAI'
local Chaser             = require 'AI/basic/Chaser'
local AIStarter         = require 'AI/AIstarter/AIStarter'


local Camera = require "hump/camera"

function GameState:initialize()
   self.hello = "yo gabba gabba"
   
   self.resmgr = ResMgr:new(self)
   self.objmgr = ObjectManager:new(self)
   self.factory = Factory:new(self,self.resmgr)
   
   self.world = love.physics.newWorld(0,0,true)
   self.world:setCallbacks(
      beginContact,
      endContact,
      preSolve,
      postSolve)
   
   self.cam = Camera(0,0)
   
   self:loadImages()
   
   
   self:startGame()
   
end

function GameState:startGame()
   self.objmgr:clear()
   --self:addPlayer(AIStarter)
   --self:addPlayer(AltGamePadController)
   self:addPlayer(AltKeyboardController)
   --self:addPlayer(VokronAI)
   --self:addPlayer(VokronAI)
   --self:addPlayer(VokronAI)
   --for i = 1,3 do
   --   self:addEnemy(Chaser)
--   --end
   self:addAstroids(7)
end

function GameState:loadImages()
   self.resmgr:loadImg('img/asteroids/asteroid3.png',"asteroid3")
   self.resmgr:loadImg('img/asteroids/asteroid2.png',"asteroid2")
   self.resmgr:loadImg('img/asteroids/asteroid1.png',"asteroid1")
   self.resmgr:loadImg('img/ship2.png',"spaceship")
   self.resmgr:loadImg('img/player.png',"booger")
   self.resmgr:loadImg('img/shot.png',"fire")
   self.resmgr:loadImg('img/saft.png',"saft")
   self.resmgr:loadImg('img/fighter.png',"fighter")
   --self.resmgr:loadImg('img/asteroid.png','astroid1')
   --self.resmgr:loadImg('img/asteroid1.png','astroid2')
   self.resmgr:loadImg('img/bg.png',"bg")
   self.resmgr:loadImg('img/floatbg1.png',"floatbg1")
   self.resmgr:loadImg('img/floatbg2.png',"floatbg2")
   
   --self.resmgr:loadImg('img/monster.png',"astroid")
   self.resmgr:loadImg('img/hit.png','hit')
   self.resmgr:loadImg('img/explosion.png','explosion')
   self.resmgr:loadImg('img/crosshair.png','cross')
   self.resmgr:loadImg('img/square.png','square')
end

function GameState:update(dt)
   if love.keyboard.isDown("r") then
      self:startGame()
   end
   self.world:update(dt)
   
   -- update
   self.objmgr:updateAll()
   
   local cpos = nil
   if self.objmgr.players[1] ~= nil then
      cpos = self.objmgr.players[1].trans
   else
      cpos = {} 
      cpos.x = 0
      cpos.y = 0
   end
   self.cam:lookAt(cpos.x,cpos.y)
end

function GameState:draw()
   love.graphics.setBackgroundColor(34,34,38)
   self.cam:attach()
   local bgpos = nil
   if self.objmgr.players[1] ~= nil then
      bgpos = self.objmgr.players[1].trans
   else
      bgpos = {}
      bgpos.x = 0
      bgpos.y = 0
   end
   self:drawBackground(bgpos.x,bgpos.y)
   self.objmgr:drawAll()
   self.cam:detach()
end

-- collision callbacks
function GameState:beginContact(a,b,coll)
   self.objmgr:beginContact(a,b,coll)
end

function GameState:endContact(a,b,coll)
   self.objmgr:endContact(a,b,coll)
end

function GameState:preSolve(a,b,coll)
   self.objmgr:preSolve(a,b,coll)
end

function GameState:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
   self.objmgr:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)

end


function GameState:drawBackgroundLayer(x,y,img,distance)
   
   if distance == 0 then
      distance = 0.000001
   end
   local w,h = img:getWidth()*2,img:getHeight()*2
   local x1,y1 = math.floor(x/w), math.floor(y/h)
   local dx,dy = (x/distance) % w,(y/distance) % h   
   local offx,offy = (x % w)-dx,(y % h)-dy

   local Xc,Yc = (x1*w)+offx, (y1*h)+offy
   local wh,hh = w/2,h/2
   local X1,X2 = Xc - wh, Xc + wh
   local Y1,Y2 = Yc - hh, Yc + hh
   love.graphics.draw(img,X1,Y1,0,2,2)
   love.graphics.draw(img,X2,Y1,0,2,2)
   love.graphics.draw(img,X1,Y2,0,2,2)
   love.graphics.draw(img,X2,Y2,0,2,2)
   --[[
   local Xw,Xc,Xe = ((x1-1)*w)+offx, (x1*w)+offx, ((x1+1)*w)+offx
   local Yn,Yc,Ys = ((y1-1)*h)+offy, (y1*h)+offy, ((y1+1)*h)+offy
   --center 
   love.graphics.draw(img,Xc,Yc,0,2,2)

   --van neumann
   love.graphics.draw(img,Xc,Yn,0,2,2)
   love.graphics.draw(img,Xc,Ys,0,2,2)
   love.graphics.draw(img,Xe,Yc,0,2,2)
   love.graphics.draw(img,Xw,Yc,0,2,2)

   --diagonals
   love.graphics.draw(img,Xe,Yn,0,2,2)
   love.graphics.draw(img,Xe,Ys,0,2,2)
   love.graphics.draw(img,Xw,Ys,0,2,2)
   love.graphics.draw(img,Xw,Yn,0,2,2)
   ]]
end

function GameState:drawBackground(x,y)
   --self:drawBackgroundLayer(x,y,self.resmgr:getImg('square'),10)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('bg'),5)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('floatbg1'),2.5)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('floatbg2'),1)
end

function GameState:addPlayer(controller)
   local w,h = love.graphics.getDimensions()
   self.factory:createPlayer(w/2,h/2,0,controller)
end

function GameState:addEnemy(controller)
   local w,h = love.graphics.getDimensions()
   self.factory:createEnemy(math.random()*w,math.random()*h,0,controller)
end

function GameState:addAstroids(n)
   for i = 1, n do
      local x,y,r,level,size
      local w, h = love.graphics.getDimensions()
      x = math.random()*w
      y = math.random()*h
      r = math.random()*2*math.pi
      size = 100
      level = 3
      self.factory:createAstroid(x,y,r,size,1,level)
   end
end

return GameState
