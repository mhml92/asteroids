local class             = require 'middleclass'
local Factory           = require 'Factory'
local GameObject        = require 'GameObject'
local ResMgr            = require 'ResourceManager'
local ObjectManager     = require 'ObjectManager'

local GameState = class('GameState')


-- User Controllers
local GamePadController = require 'components/GamePadController'
local KeyboardController= require 'components/KeyboardController'

-- AI
local VokronAI          = require 'AI/michael/VokronAI'
local Chaser             = require 'AI/basic/Chaser'
local AIStarter         = require 'AI/AIstarter/AIStarter'

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
   
   self:loadImages()
   
   
   self:startGame()
   
end

function GameState:startGame()
   self.objmgr:clear()
   --self:addPlayer(AIStarter)
   self:addPlayer(GamePadController)
   --self:addPlayer(KeyboardController)
   --self:addPlayer(VokronAI)
   --self:addPlayer(VokronAI)
   --self:addPlayer(VokronAI)
   --for i = 1,3 do
   --   self:addEnemy(Chaser)
--   --end
   self:addAstroids(5 )
end

function GameState:loadImages()
   self.resmgr:loadImg('img/asteroids/asteroid3.png',"asteroid3")
   self.resmgr:loadImg('img/asteroids/asteroid2.png',"asteroid2")
   self.resmgr:loadImg('img/asteroids/asteroid1.png',"asteroid1")
   self.resmgr:loadImg('img/bg.png', "minbg")
   self.resmgr:loadImg('img/ship2.png',"spaceship")
   self.resmgr:loadImg('img/player.png',"booger")
   self.resmgr:loadImg('img/shot.png',"fire")
   self.resmgr:loadImg('img/saft.png',"saft")
   self.resmgr:loadImg('img/fighter.png',"fighter")
   --self.resmgr:loadImg('img/asteroid.png','astroid1')
   --self.resmgr:loadImg('img/asteroid1.png','astroid2')
   self.resmgr:loadImg('img/bg.png',"bg")
   self.resmgr:loadImg('img/stjerner.png','stjerner')
   --self.resmgr:loadImg('img/monster.png',"astroid")
   self.resmgr:loadImg('img/hit.png','hit')
   self.resmgr:loadImg('img/crosshair.png','cross')
end

function GameState:update(dt)
   self.world:update(dt)
   
   -- update
   self.objmgr:updateAll()
end

function GameState:draw()
   love.graphics.draw(self.resmgr:getImg('minbg'),0,0,0,2,2)
   self.objmgr:drawAll()
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

function GameState:addPlayer(controller)
   local w,h = love.graphics.getDimensions()
   self.factory:createPlayer(math.random()*w,math.random()*h,0,controller)
end

function GameState:addEnemy(controller)
   local w,h = love.graphics.getDimensions()
   self.factory:createEnemy(math.random()*w,math.random()*h,0,controller)
end

function GameState:addAstroids(n)
   --[[
      100
      76
      56
      42
      32
      24
   ]]
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
