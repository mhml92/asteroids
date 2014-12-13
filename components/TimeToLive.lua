local class = require 'middleclass'

local TimeToLive = class('TimeToLive')

function TimeToLive:initialize(lifeTime)
   self.lifeTime = lifeTime
end

function TimeToLive:getType()
   return 'TimeToLive'
end

function TimeToLive:update(p)
   
   self.lifeTime = self.lifeTime - 1
   if self.lifeTime <= 0 then
      p.isAlive = false --gs.factory:destroy(p.id)
   end
end

return TimeToLive
