local class                   = require 'middleclass/middleclass'

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
local ShotExit                = require 'components/ShotExit'
local AstroidExit             = require 'components/AstroidExit'
local PlayerExit              = require 'components/PlayerExit'
local Crosshair               = require 'components/effects/crosshair'


local AltLovePhysics          = require 'components/AltLovePhysics'


local Factory = class('Factory')

function Factory:initialize(gs)
   self.gs = gs
   self.rm = self.gs.resmgr
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
   p.att["health"] =  3
   p.att["damage"] =  10
   p.att["type"] =  "player"
   p.att["layer"] = self:getLayer(p,self.layers.player)
   
   p:addComponent(controller:new(p))
   p:addComponent(Transformation:new(x,y,r))
   p:addComponent(Collision:new(p))
   --p:addComponent(CollisionSystem:new(p,Collider:new(18)))
   
   --p:addComponent(Physics:new(50,10,0.99))
   
   -- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING
   --p:addComponent(LovePhysics:new(p,10,10000,SIZE/2,1))
   -- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING,MAXSPEED
   p:addComponent(AltLovePhysics:new(p,15,30000,SIZE/2,0.5,800))
   
   p:addComponent(Graphics:new(p,self.rm:getImg("spaceship"),SIZE))

   -- COOLDOWN, FORCE
   p:addComponent(BasicWeapon:new(20,0))
   --p:addComponent(Shotgun:new(40,0))
   --p:addComponent(Shotgun:new(40,0))
   
   p:addComponent(PlayerExit:new(p)) 
   p:addComponent(Crosshair:new(self.rm:getImg("cross")))
   
   self:insert(p)
end

function Factory:createAstroid(x,y,r,size,health,level)
   local s = self:newGameObject()
   local as = nil
   if level == 3 then
      as = self.rm:getImg("asteroid3")
   elseif level == 2 then
      as = self.rm:getImg("asteroid2")
   elseif level == 1 then
      as = self.rm:getImg("asteroid1")
   end
   size = 2*as:getWidth()
   
   s.att["type"] = "astroid"
   s.att["alive"] = true
   s.att["damage"] = 1000
   s.att["health"] = health
   s.att["startHealth"] = health
   s.att["layer"] = self:getLayer(s,self.layers.default)
   s.att["size"] = size
   
   s:addComponent(Collision:new(s))
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(ShotController:new(r))
   --PARENT,MASS,SPEED,RADIUS,RESTITUTION
   s:addComponent(LoveAsteroidPhysics:new(s,size*25,size/3 * 10000,(size-5)/2),1)
   s:addComponent(AstroidExit:new(level))
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
   -- PARENT,SPEED,RADIUS
   s:addComponent(LoveProjectilePhysics:new(s,600,size/2))
   s:addComponent(Graphics:new(s,img,size))
   s:addComponent(TimeToLive:new(10))
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
function Factory:createExplosion(x,y,e1s,e1t,e2s,e2t,e3s,e3t)
      local img = self.rm:getImg("hit")
      self:createHit(x,y,math.random()*2*math.pi,img,e1s,e1t)
      self:createHit(x,y,math.random()*2*math.pi,img,e2s,e2t)
      self:createHit(x,y,math.random()*2*math.pi,img,e3s,e3t)
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
