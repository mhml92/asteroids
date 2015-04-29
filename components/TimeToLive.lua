local class = require 'middleclass/middleclass'

local TimeToLive = class('TimeToLive')

function TimeToLive:initialize(p,lifeTime)
   self.p = p
   self.lifeTime = lifeTime
end

function TimeToLive:getType()
   return 'TimeToLive'
end

function TimeToLive:update()
   
   self.lifeTime = self.lifeTime - 1
   if self.lifeTime <= 0 then
      self.p.att["alive"] = false
   end
end

return TimeToLive
