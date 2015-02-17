local class                   = require 'middleclass'

local GameObject              = require 'GameObject'
local Collision               = require 'components/Collision'
local LovePhysics             = require 'components/LovePhysics'
local LoveProjectilePhysics   = require 'components/LoveProjectilePhysics'
local LoveAsteroidPhysics     = require 'components/LoveAsteroidPhysics'

local Transformation          = require 'components/Transformation'
local Graphics                = require 'components/Graphics'

-- WEAPONS
local BasicWeapon             = require 'components/weapons/BasicWeapon'
local Shotgun                 = require 'components/weapons/Shotgun'

local ShotController          = require 'components/ShotController'
local TimeToLive              = require 'components/TimeToLive'
local LovePhysicsScreenFix    = require 'components/LovePhysicsScreenFix'
local Exhaust                 = require 'components/effects/Exhaust'
local ShotExit                = require 'components/ShotExit'
local AstroidExit             = require 'components/AstroidExit'
local PlayerExit              = require 'components/PlayerExit'
local Crosshair               = require 'components/effects/crosshair'

local Factory = class('Factory')

function Factory:initialize(gs,rm)
   self.gs = gs
   self.rm = rm
   self.id = 0
   self.layers = {}
   self.layers.depth = 100

   self.layers.player = 500
   self.layers.default  = 300
   self.layers.projectile = 100
   self.layers.background = 0
   self.layers.hit = 1000
end

function Factory:createPlayer(x,y,r,controller)
   local SIZE = 40
   
   local p = self:newGameObject()
  

   p.att["alive"] =  true
   p.att["health"] =  300
   p.att["damage"] =  10
   p.att["type"] =  "player"
   p.att["layer"] = self:getLayer(p,self.layers.player)
   
   p:addComponent(controller:new(p))
   p:addComponent(Transformation:new(x,y,r))
   p:addComponent(Collision:new(p))
   --p:addComponent(CollisionSystem:new(p,Collider:new(18)))
   
   --p:addComponent(Physics:new(50,10,0.99))
   
   -- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING
   p:addComponent(LovePhysics:new(p,10,10000,SIZE/2,1))
   
   p:addComponent(Graphics:new(p,self.rm:getImg("spaceship"),SIZE))

   -- COOLDOWN, FORCE
   --p:addComponent(BasicWeapon:new(20,0))
   p:addComponent(Shotgun:new(40,5*500))
   p:addComponent(PlayerExit:new()) 
   p:addComponent(LovePhysicsScreenFix:new(p,0))
   p:addComponent(Crosshair:new(self.rm:getImg("cross")))
   --[[p:addComponent(Exhaust:new(
      -15,
      0,
      self.rm:getImg("fire"),
      1000,
      100,
      1000,
      math.pi/4)
   )
   ]]
   self:insert(p)
end

function Factory:createEnemy(x,y,r,controller)
   local p = self:newGameObject()
  

   p.att["alive"] =  true
   p.att["health"] =  30
   p.att["damage"] =  0
   p.att["type"] =  "hunter" --Sack Of Shit
   p.att["layer"] = self:getLayer(p,self.layers.player)
   
   p:addComponent(controller:new(p))
   p:addComponent(Transformation:new(x,y,r))
   
   p:addComponent(Collision:new(p))
   -- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING
   p:addComponent(LovePhysics:new(p,5,5000,18,1))
   
   p:addComponent(Graphics:new(p,self.rm:getImg("booger"),40))

   -- COOLDOWN, FORCE
   p:addComponent(Weapon:new(20,100))
   p:addComponent(PlayerExit:new()) 
   p:addComponent(LovePhysicsScreenFix:new(p,50))
   p:addComponent(Crosshair:new(self.rm:getImg("cross")))
   --[[
   p:addComponent(controller:new(p))
   p:addComponent(Transformation:new(x,y,r))
   --p:addComponent(CollisionSystem:new(p,Collider:new(18)))
   
   --p:addComponent(Physics:new(50,10,0.99))
   
   -- PARENT, MASS, FORCE, SIZE(radius)
   p:addComponent(LovePhysics:new(p,0,100,19))
   
   p:addComponent(Graphics:new(p,self.rm:getImg("booger"),40))
   p:addComponent(PlayerExit:new()) 
   p:addComponent(LovePhysicsScreenFix:new())
   ]]
   
   self:insert(p)
end

function Factory:createAstroid(x,y,r,size,health,level)
   local s = self:newGameObject()
   local as
   --[[if math.random() < 0.5 then
      as = self.rm:getImg("astroid1")
   else
      as = self.rm:getImg("astroid2")
   end
   ]]
   if level == 3 then
      as = self.rm:getImg("asteroid3")
   elseif level == 2 then
      as = self.rm:getImg("asteroid2")
   elseif level == 1 then
      as = self.rm:getImg("asteroid1")
   end
   size = 2*as:getWidth()
   
   s.att["type"] = "astroid"
   --s.att["damage"] = 1
   s.att["alive"] = true
   s.att["damage"] = 1000
   s.att["health"] = health
   s.att["startHealth"] = health
   s.att["layer"] = self:getLayer(s,self.layers.default)
   s.att["size"] = size
   
   s:addComponent(Collision:new(s))
   s:addComponent(Transformation:new(x,y,r))
   --s:addComponent(CollisionSystem:new(s,Collider:new((size)/2)))
   --s:addComponent(Physics:new(mass,force,friction))
   s:addComponent(ShotController:new(r))
   --PARENT,MASS,SPEED,RADIUS,RESTITUTION
   s:addComponent(LoveAsteroidPhysics:new(s,size*2.5,10000,(size-5)/2),1)
   s:addComponent(LovePhysicsScreenFix:new(s,50))
   s:addComponent(AstroidExit:new(level))
   --s:addComponent(ConstSpeed:new((1+math.random()*3)))
   --s:addComponent(DebugGraphics:new(255,0,0))
  
   --s:addComponent(AstroidsGraphics:new(as,size))
   s:addComponent(Graphics:new(s,as,size))
   self:insert(s) 
end

function Factory:createProjectile(x,y,r,damage,img,size,owner)
   local s = self:newGameObject()
   
   s.att["type"] = "projectile"
   s.att["owner"] = owner
   s.att["damage"] = damage
   s.att["alive"] = true
   s.att["hit"] = false
   s.att["layer"] = self:getLayer(s,self.layers.projectile)
   
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(ShotController:new(r))
   s:addComponent(Collision:new(s))
   --s:addComponent(CollisionSystem:new(s,Collider:new(size/2)))
   -- PARENT,SPEED,RADIUS
   s:addComponent(LoveProjectilePhysics:new(s,20,size/2))
   --s:addComponent(ConstSpeed:new(20))
   s:addComponent(LovePhysicsScreenFix:new(s,0))
   s:addComponent(Graphics:new(s,img,size))
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
   s:addComponent(Graphics:new(s,img,size))
   s:addComponent(TimeToLive:new(time))
   s.att["layer"] = self:getLayer(s,self.layers.hit)
   self:insert(s) 
end

function Factory:getLayer(o,l)
   return (math.random()*self.layers.depth)+l
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
