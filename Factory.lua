local class             = require 'middleclass'

local GameObject        = require 'GameObject'
local Transformation    = require 'components/Transformation'
local Graphics          = require 'components/Graphics'
local DebugGraphics     = require 'components/DebugGraphics'
local KeyboardController= require 'components/KeyboardController'
local GamePadController = require 'components/GamePadController'
local EnemyController   = require 'components/EnemyController'
local Physics           = require 'components/Physics'
local Collider          = require 'components/Collider'
local Weapon            = require 'components/Weapom'
local ShotController    = require 'components/ShotController'
local TimeToLive        = require 'components/TimeToLive'
local ConstSpeed        = require 'components/ConstSpeed'
local ScreenFix         = require 'components/ScreenFix'
local Exhaust           = require 'components/effects/Exhaust'

local Factory = class('Factory')

function Factory:initialize(gs,rm)
   self.gs = gs
   self.rm = rm
   self.id = 0
end

function Factory:createPlayer(x,y,r)
   local p = self:newGameObject()
   if #love.joystick.getJoysticks() > 0 then 
      p:addComponent(GamePadController:new())
   else
      p:addComponent(KeyboardController:new())
   end
   
   p:addComponent(Transformation:new(x,y,r))
   p:addComponent(Collider:new(20))
   p:addComponent(Physics:new(25 ,10,0.98,1000))
   p:addComponent(Graphics:new(self.rm:getImg("spaceship"),1))
   p:addComponent(Weapon:new())
  
   p:addComponent(ScreenFix:new())
   p:addComponent(Exhaust:new(
      -15,
      0,
      self.rm:getImg("shot"),
      500,
      200,
      0.05,
      math.pi*1/2)
   )
   
   return p
end

function Factory:createEnemy(x,y,r)
   local e = self:newGameObject()
   e:addComponent(Transformation:new(x,y,r))
   e:addComponent(Collider:new(20))
   e:addComponent(EnemyController:new())
   
   -- mass/force/friction
   e:addComponent(Physics:new(25,10,0.98))
   
   -- red/green/blue
   e:addComponent(DebugGraphics:new(255,0,0))
   return e
end

function Factory:createShot(x,y,r)
   local s = self:newGameObject() 
   s:addComponent(Transformation:new(x,y,r))
   s:addComponent(ShotController:new())
   s:addComponent(Collider:new(5))
   s:addComponent(ConstSpeed:new(20))
   s:addComponent(Graphics:new(self.rm:getImg("shot"),0.05))
   s:addComponent(TimeToLive:new(60))
   return s 

end


function Factory:createRandomEnemy()
   local e = self:newGameObject()
   e:addComponent(Transformation:new(
      math.random()*love.graphics.getWidth(),
      math.random()*love.graphics.getHeight(),
      0)
   )
   
   e:addComponent(Collider:new(( math.random()*20) +10))
   
   e:addComponent(EnemyController:new())
   
   local m = math.random() * 20 + 10
   local f = math.random() * 10 + 10
   local fric = 1.0 - math.random()*0.2
   e:addComponent(Physics:new(m,f,fric))
  
   local r = math.random() * 255
   local g = math.random() * 255
   local b = math.random() * 255
   e:addComponent(DebugGraphics:new(r,g,b))
   return e
end

function Factory:newGameObject()
   local go = GameObject:new(self.id,self.gs)
   self.id = self.id + 1
   return go
end


return Factory
