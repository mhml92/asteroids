local class             = require 'middleclass'

local GameObject        = require 'GameObject'
local CollisionSystem   = require 'CollisionSystem/CollisionSystem'
local Collider          = require 'CollisionSystem/Collider'

local Transformation    = require 'components/Transformation'
local Graphics          = require 'components/Graphics'
local DebugGraphics     = require 'components/DebugGraphics'
local KeyboardController= require 'components/KeyboardController'
local GamePadController = require 'components/GamePadController'
local EnemyController   = require 'components/EnemyController'
local Physics           = require 'components/Physics'
local Weapon            = require 'components/Weapon'
local ShotController    = require 'components/ShotController'
local TimeToLive        = require 'components/TimeToLive'
local ConstSpeed        = require 'components/ConstSpeed'
local ScreenFix         = require 'components/ScreenFix'
local Exhaust           = require 'components/effects/Exhaust'
local ShotExit          = require 'components/ShotExit'
local AstroidExit       = require 'components/AstroidExit'
local PlayerExit        = require 'components/PlayerExit'
local AstroidsGraphics  = require 'components/AstroidGraphics'
local AI                = require 'components/AIController'


local Factory = class('Factory')

function Factory:initialize(gs,rm)
   self.gs = gs
   self.rm = rm
   self.id = 0
   self.layers = {}
   self.layers.player = 300
   self.layers.default  = 100
   self.layers.background = 0
   self.layers.hit = 1000
end

function Factory:getLayer(o,l)
   return (math.random()*l)+l
end

function Factory:createPlayer(x,y,r)
   local p = self:newGameObject()
   
   p.att["alive"] =  true
   p.att["health"] =  100
   p.att["type"] =  "player"
   p.att["layer"] = self:getLayer(p,self.layers.player)

   p:addComponent(AI:new(p))
   --[[
   if #love.joystick.getJoysticks() > 0 then 
      p:addComponent(GamePadController:new())
   else
      p:addComponent(KeyboardController:new())
   end
   ]]

   p:addComponent(Transformation:new(x,y,r))
   p:addComponent(CollisionSystem:new(p,Collider:new(18)))
   p:addComponent(Physics:new(26,10,0.98))
   p:addComponent(Graphics:new(self.rm:getImg("spaceship"),40))
   p:addComponent(Weapon:new(30))
   p:addComponent(PlayerExit:new()) 
   p:addComponent(ScreenFix:new())
   p:addComponent(Exhaust:new(
      -15,
      0,
      self.rm:getImg("fire"),
      500,
      200,
      0.02,
      math.pi/4)
   )
   self:insert(p)
end

--[[
function Factory:createEnemy(x,y,r,size)
   local e = self:newGameObject()
   
   e.att["alive"] = true
   e.att["health"] =  10
   e.att["rigidbody"] = 0.2
   e.att["type"] = "enemy"
   e.att["layer"] = self.layers.default
   e:addComponent(Transformation:new(x,y,r))
   e:addComponent(CollisionSystem:new(e,Collider:new((size/2))))
   e:addComponent(EnemyController:new())
   -- mass/force/friction
   e:addComponent(Physics:new(25,10,0.98))
   
   --e:addComponent(Graphics:new(self.rm:getImg("booger"),size))
   e:addComponent(DebugGraphics:new(0,0,255))
   self:insert(e)
end
]]

function Factory:createAstroid(x,y,r,size,health,level)
   local s = self:newGameObject()
   
   s.att["type"] = "astroid"
   --s.att["damage"] = 1
   s.att["alive"] = true
   s.att["damage"] = 100
   s.att["health"] = health
   s.att["startHealth"] = health
   s.att["layer"] = self:getLayer(s,self.layers.default)
   s.att["size"] = size
   
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(CollisionSystem:new(s,Collider:new((size)/2)))
   --s:addComponent(Physics:new(mass,force,friction))
   s:addComponent(ShotController:new(r))
   s:addComponent(ScreenFix:new())
   s:addComponent(AstroidExit:new(level))
   s:addComponent(ConstSpeed:new((1+math.random()*3)))
   --s:addComponent(DebugGraphics:new(255,0,0))
  
   local as
   if math.random() < 0.5 then
      as = self.rm:getImg("astroid1")
   else
      as = self.rm:getImg("astroid2")
   end
   --s:addComponent(AstroidsGraphics:new(as,size))
   s:addComponent(AstroidsGraphics:new(as,size))
   self:insert(s) 
end

function Factory:createProjectile(x,y,r,damage,img,size, owner)
   local s = self:newGameObject()
   
   s.att["type"] = "projectile"
   s.att["owner"] = owner
   s.att["damage"] = damage
   s.att["alive"] = true
   s.att["hit"] = false
   s.att["layer"] = self:getLayer(s,self.layers.default)
   
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(ShotController:new(r))
   s:addComponent(CollisionSystem:new(s,Collider:new(size/2)))
   s:addComponent(ConstSpeed:new(20))
   s:addComponent(ScreenFix:new())
   s:addComponent(Graphics:new(img,size))
   --s:addComponent(DebugGraphics:new(0,255,0))
   s:addComponent(TimeToLive:new(15))
   s:addComponent(ShotExit:new())
   self:insert(s) 

end

function Factory:createHit(x,y,r,img,size,time)
   local s = self:newGameObject()
   
   s.att["alive"] = true
   s.att["type"] = "effect" 
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(Graphics:new(img,size))
   s:addComponent(TimeToLive:new(time))
   s.att["layer"] = self:getLayer(s,self.layers.hit)
   self:insert(s) 

end

function Factory:newGameObject()
   local go = GameObject:new(self.id,self.gs)
   self.id = self.id + 1
   return go
end

function Factory:insert(o)
   self.gs.objmgr:insert(o)
end

return Factory
