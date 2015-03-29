local class             = require 'middleclass/middleclass'
local Factory           = require 'Factory'
local GameObject        = require 'GameObject'
local ResMgr            = require 'ResourceManager'
local ObjectManager     = require 'ObjectManager'
local CameraManager     = require 'CameraManager'
local DebugManager      = require 'DebugManager'

local GameState = class('GameState')


-- User Controllers
local AltGamePadController    = require 'components/AltGamePadController'
local GamePadController       = require 'components/GamePadController'
local KeyboardController      = require 'components/KeyboardController'
local AltKeyboardController   = require 'components/AltKeyboardController'

-- AI
local VokronAI          = require 'AI/michael/VokronAI'
local Chaser             = require 'AI/basic/Chaser'
local AIStarter         = require 'AI/AIstarter/AIStarter'



function GameState:initialize()
   self.hello = "yo gabba gabba"
   
   self.resmgr    = ResMgr:new(self)
   self.objmgr    = ObjectManager:new(self)
   self.factory   = Factory:new(self)
   self.cammgr    = CameraManager:new(self)
   self.dbgmgr    = DebugManager:new(self) 

   self.world = love.physics.newWorld(0,0,true)
   self.world:setCallbacks(beginContact,endContact,preSolve,postSolve)
   self:loadImages()
   self:startGame()
end

function GameState:startGame()
   self.objmgr:clear()
   self:addPlayer(AltGamePadController)
   --self:addPlayer(AltKeyboardController)
   --self:addPlayer(AIStarter)
   self.factory:createPlanet(-200,-200,math.pi/2,200)
   --self.factory:createPlanet(1500,0,0,200)
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
   self.resmgr:loadImg('img/bg.png',"bg")
   self.resmgr:loadImg('img/floatbg1.png',"floatbg1")
   self.resmgr:loadImg('img/floatbg2.png',"floatbg2")
   self.resmgr:loadImg('img/floatbg3.png',"floatbg3")
   self.resmgr:loadImg('img/hit.png','hit')
   self.resmgr:loadImg('img/explosion.png','explosion')
   self.resmgr:loadImg('img/crosshair.png','cross')
   self.resmgr:loadImg('img/square.png','square')
   self.resmgr:loadImg('img/planet/test.png','ptest')
   self.resmgr:loadImg('img/planet/grav.png','grav')
   self.resmgr:loadImg('img/planet/planet.png','ptest2')
   self.resmgr:loadImg('img/planet/planet2.png','ptest3')
   self.resmgr:loadImg('img/planet/shadow.png','pshadow')
end

function GameState:update(dt)
   self.dbgmgr:update(dt)
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
   self.cammgr:update(cpos.x,cpos.y)
end

function GameState:draw()
   love.graphics.setBackgroundColor(34,34,38)
   self.cammgr:attach()
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
   self.cammgr:detach()
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
   local wh,hh = img:getWidth(),img:getHeight()
   local w,h = wh*2,hh*2
   local x1,y1 = math.floor(x/w), math.floor(y/h)
   local dx,dy = (x/distance) % w,(y/distance) % h   
   local offx,offy = (x % w)-dx,(y % h)-dy
   local Xc,Yc = (x1*w)+offx, (y1*h)+offy
   local X1,X2 = Xc - wh, Xc + wh
   local Y1,Y2 = Yc - hh, Yc + hh
   love.graphics.draw(img,X1,Y1,0,2,2)
   love.graphics.draw(img,X2,Y1,0,2,2)
   love.graphics.draw(img,X1,Y2,0,2,2)
   love.graphics.draw(img,X2,Y2,0,2,2)
end

function GameState:drawBackground(x,y)
   --self:drawBackgroundLayer(x,y,self.resmgr:getImg('square'),6)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('bg'),5)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('floatbg2'),3.5)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('floatbg1'),2.5)
   self:drawBackgroundLayer(x,y,self.resmgr:getImg('floatbg3'),1)
end

function GameState:addPlayer(controller)
   local w,h = love.graphics.getDimensions()
   self.factory:createPlayer(w/2,h/2,0,controller)
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
