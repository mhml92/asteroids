local class       = require 'middleclass/middleclass'
local humpCamera  = require 'hump/camera'
local vector      = require 'hump/vector-light'

local CameraManager = class('CameraManager')

function CameraManager:initialize(gs)
   self.gs = gs
   self.cam = humpCamera(0,0)

   -- shake vars
   self.rate = 0
   self.shakeStrength = 0
   self.offX = 0
   self.offY = 0
end

function CameraManager:update(x,y)
   if self.shakeStrength > 0.01 then
      local sdir = math.random()*2*math.pi
      self.offX = math.cos(sdir)*self.shakeStrength
      self.offY = math.sin(sdir)*self.shakeStrength
      self.shakeStrength = self.shakeStrength*self.rate
   end

   self.cam:lookAt(x + self.offX,y + self.offY)
end

function CameraManager:attach()
   self.cam:attach()
end

function CameraManager:detach()
   self.cam:detach()
end

function CameraManager:shake(rate,strength)
   self.rate = math.max(rate,self.rate)
   self.shakeStrength = math.max(strength,self.shakeStrength)
end


return CameraManager
