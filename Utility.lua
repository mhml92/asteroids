local class = require 'middleclass'

local Utility = class('Utility')
function Utility:initialize()
   self.et = 0
   self.lt = 0
   self.idle = 0
   self.frameCount = 0
end


function Utility:enter()
  self.et = love.timer.getTime()
end

function Utility:leave()
   self.lt = love.timer.getTime()
   self.frameCount = self.frameCount + 1

   self.idle = self.idle + (self.lt-self.et)
   if self.frameCount == 60 then
      print((self.idle/60))  
      print( math.floor((self.idle/60)*100) .. " % capacity")
      self.frameCount = 0
      self.idle = 0
   end


end

function Utility:wait(dt)
   if dt < 1/60 then
      local rest = (1/60)-dt
      self.idle = self.idle + rest
      if self.frameCount == 60 then
         print((self.idle/60))  
         print( math.floor((self.idle/60)*100) .. " % capacity")
         self.frameCount = 0
         self.idle = 0
      end
      self.frameCount = self.frameCount + 1
      love.timer.sleep(rest)
   end
end

return Utility
