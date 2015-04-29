local class                   = require 'middleclass/middleclass'

local GameObject              = require 'GameObject'
local Collision               = require 'components/Collision'
local AltLovePhysics          = require 'components/AltLovePhysics'
--local LovePhysics             = require 'components/LovePhysics'
local LoveProjectilePhysics   = require 'components/LoveProjectilePhysics'
local LoveAsteroidPhysics     = require 'components/LoveAsteroidPhysics'
local LovePlanetPhysics       = require 'components/LovePlanetPhysics'

local Transformation          = require 'components/Transformation'
local Graphics                = require 'components/Graphics'
local DebugGraphics           = require 'components/DebugGraphics'

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
local PlanetShadow            = require 'components/effects/PlanetShadow'
local PlanetGravity           = require 'components/PlanetGravity'


local Factory = class('Factory')

function Factory:initialize(gs)
	self.gs = gs
	self.rm = self.gs.resmgr
	self.id = 0
	self.layers = {}
	self.layers.depth = 100

	self.layers.player = 700
	self.layers.default  = 500
	self.layers.projectile = 300
	self.layers.planet = 100
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
	p.att["size"] = SIZE

	p:addComponent(controller:new(p))
	p:addComponent(Transformation:new(x,y,r))
	p:addComponent(Collision:new(p))
	--p:addComponent(CollisionSystem:new(p,Collider:new(18)))

	--p:addComponent(Physics:new(50,10,0.99))

	-- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING
	--p:addComponent(LovePhysics:new(p,10,10000,SIZE/2,1))
	-- PARENT, MASS, FORCE, RADIUS,LINEAR DAMPING,MAXSPEED
	p:addComponent(AltLovePhysics:new(p,20,35000,p.att["size"]/2,0,800))
	p:addComponent(PlanetGravity:new(p)) 
	p:addComponent(Graphics:new(p,self.rm:getImg("spaceship"),p.att["size"]))

	-- COOLDOWN, FORCE
	p:addComponent(BasicWeapon:new(p,20,0))

	p:addComponent(PlayerExit:new(p)) 
	p:addComponent(Crosshair:new(p,self.rm:getImg("cross")))

	self:insert(p)
end

function Factory:createAstroid(x,y,r,size,health,level)
	local s = self:newGameObject()
	local as = {}
	--if level == 3 then level = 2 end
	if level == 3 then
		as.img = self.rm:getImg("asteroid3")
		as.speed = 128000*(500/800)
		as.mass = 500
	elseif level == 2 then
		as.img = self.rm:getImg("asteroid2")
		as.speed = 64000
		as.mass = 320
	elseif level == 1 then
		as.img = self.rm:getImg("asteroid1")
		as.speed = 32000
		as.mass = 160
	end
	size = 2*as.img:getWidth()

	s.att["type"] = "astroid"
	s.att["alive"] = true
	s.att["damage"] = 1000
	s.att["health"] = health
	s.att["startHealth"] = health
	s.att["layer"] = self:getLayer(s,self.layers.default)
	s.att["size"] = size

	s:addComponent(PlanetGravity:new(s)) 
	s:addComponent(Collision:new(s))
	s:addComponent(Transformation:new(x,y,r))
	s:addComponent(ShotController:new(r))
	--PARENT,MASS,SPEED,RADIUS,RESTITUTION
	s:addComponent(LoveAsteroidPhysics:new(s,as.mass,as.speed,(size-5)/2,1))
	s:addComponent(AstroidExit:new(level))
	s:addComponent(Graphics:new(s,as.img,size))
	self:insert(s) 
end

function Factory:createPlanet(x,y,r,size, imgName)
	local p = self:newGameObject()
	p.att["type"] = "planet"
	p.att["damage"] = 10
	p.att["alive"] = true
	p.att["size"] = size
	p.att["layer"] = self:getLayer(p,self.layers.planet)
	p.att["gravity"] = 125000 
	p.att["gravityradius"] = 500 
	p.att["friction"] = 10


	p:addComponent(Transformation:new(x,y,r))
	p:addComponent(Collision:new(p))


	--PARENT,MASS,SPEED,RADIUS,RESTITUTION
	p:addComponent(LovePlanetPhysics:new(p,999999999,0,p.att["size"],0))
	p:addComponent(PlanetShadow:new(p,self.rm:getImg("pshadow")))
	p:addComponent(Graphics:new(p,self.gs.resmgr:getImg(imgName),p.att["size"]*4))
	p.graphics:addBackgound(self.gs.resmgr:getImg("grav2"))
	--p:addComponent(DebugGraphics:new(p))
	self:insert(p)
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
	s:addComponent(TimeToLive:new(s,10))
	s:addComponent(ShotExit:new())
	self:insert(s) 

end

function Factory:createHit(x,y,r,img,size,time)
	local s = self:newGameObject()

	s.att["alive"] = true
	s.att["type"] = "effect" 
	s:addComponent(Transformation:new(x,y,r))
	s:addComponent(Graphics:new(s,img,size))
	s:addComponent(TimeToLive:new(s,time))
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
