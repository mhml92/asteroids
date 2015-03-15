local class = require 'middleclass/middleclass'

local AIController = class('AIController')

function AIController:initialize(p)
   self.p = p
	self.astroids = self.p.gs.objmgr.astroids
   self.players = self.p.gs.objmgr.players
   self.projectiles = self.p.gs.objmgr.projectiles
   self.shoot = false
end

function AIController:getType()
   return 'Controller'
end

function AIController:update() 
   self.shootDir = self:getShootDir()
   self.moveDir = self:getMoveDir()
   self.shooting = self:isShooting()
end

function AIController:isShooting()
   return self.shoot
end

function AIController:getMoveDir()
   local apos = self:getMostDangerousPos(false)
   local dir = {}
   local velX,velY = self.p.physics.body:getLinearVelocity()
   local speed = math.sqrt(velX^2+velY^2)
   --print('Speed:' .. speed .. ' Dist: ' .. apos.dist .. ' Count: ' .. apos.count)
   if apos.dist < math.max(speed/1.5,100) or (apos.play and apos.dist < 700 and #self.astroids > 0) then
      dir.x = (apos.x - self.p.trans.x) * -1
      dir.y = (apos.y - self.p.trans.y) * -1
   else
      dir.x = (apos.x - self.p.trans.x)
      dir.y = (apos.y - self.p.trans.y)
   end
   
   if apos.proj then
      dir.x = (apos.y - self.p.trans.y)
      dir.y = (apos.x - self.p.trans.x) * -1
   end
   
   --move
   if dir.x ~= 0 or dir.y ~= 0 then
      local unit = math.sqrt((dir.x^2)+(dir.y^2))
      dir.x = dir.x/unit
      dir.y = dir.y/unit
   end
   return dir  
end

function AIController:getShootDir()
   local apos = self:getMostDangerousPos(true)
   local dir = {}
   dir.x = apos.x - self.p.trans.x
   dir.y = apos.y - self.p.trans.y
   
   if apos.dist < 275 and apos.count < 3 then
      self.shoot = true
   else
      self.shoot = false
   end
   --print(self.shoot)
   --move
   return dir  
end

function AIController:getMostDangerousPos(b)
   local w,h = love.graphics.getDimensions()
   local pos = {}
   pos.x = 0
   pos.y = 0
   pos.dist = 0
   pos.proj = false
   pos.play = false
   pos.count = 0
   
   local cb = 30000
   local pVelX,pVelY = self.p.physics.body:getLinearVelocity()
   local px = self.p.trans.x + pVelX/10
   local py = self.p.trans.y + pVelY/10
   
   for i = 1, #self.astroids do
      local velX,velY = self.astroids[i].physics.body:getLinearVelocity()
      local ox = pos.x
      local oy = pos.y
      local ax = self.astroids[i].trans.x + velX/10
      local ay = self.astroids[i].trans.y + velY/10
      local x1 = ax - w
      local x2 = ax
      local x3 = ax + w
      local y1 = ay - h
      local y2 = ay
      local y3 = ay + h
      if math.abs(px - x2) < math.abs(px - x3) then
         if math.abs(px - x1) < math.abs(px - x2) then
            pos.x = x1
         else
            pos.x = x2
         end
      else
         pos.x = x3
      end
      
      if math.abs(py - y2) < math.abs(py - y3) then
         if math.abs(py - y1) < math.abs(py - y2) then
            pos.y = y1
         else
            pos.y = y2
         end
      else
         pos.y = y3
      end
      
      local dist = math.sqrt(math.pow(px - pos.x,2)+math.pow(py - pos.y,2))
      dist = dist - self.astroids[i].physics.radius
      
      if dist < 150 then
         pos.count = pos.count + 1
      end
      
      if b then
         if cb > dist + self.astroids[i].att["size"] then
            cb = dist + self.astroids[i].att["size"]
            pos.dist = dist
            pos.play = false
            pos.proj = false
         else
            pos.x = ox
            pos.y = oy
         end
      else
         if cb > dist + self.astroids[i].att["size"]/3 then
            cb = dist + self.astroids[i].att["size"]/3
            pos.dist = dist
            pos.play = false
            pos.proj = false
         else
            pos.x = ox
            pos.y = oy
         end
      end
   end
   
   for i = 1, #self.players do
      if self.p.id ~= self.players[i].id then
      local velX,velY = self.players[i].physics.body:getLinearVelocity()
      local ox = pos.x
      local oy = pos.y
      local ax = self.players[i].trans.x + velX/10
      local ay = self.players[i].trans.y + velY/10
      local x1 = ax - w
      local x2 = ax
      local x3 = ax + w
      local y1 = ay - h
      local y2 = ay
      local y3 = ay + h
         if math.abs(px - x2) < math.abs(px - x3) then
            if math.abs(px - x1) < math.abs(px - x2) then
               pos.x = x1
            else
               pos.x = x2
            end
         else
            pos.x = x3
         end
         
         if math.abs(py - y2) < math.abs(py - y3) then
            if math.abs(py - y1) < math.abs(py - y2) then
               pos.y = y1
            else
               pos.y = y2
            end
         else
            pos.y = y3
         end
         
         local dist = math.sqrt(math.pow(px - pos.x,2)+math.pow(py - pos.y,2))
         if b then
            if cb > dist + self.players[i].att["health"] then
               cb = dist + self.players[i].att["health"]
               pos.dist = dist
               
               pos.play = true
               pos.proj = false
            else
               pos.x = ox
               pos.y = oy
            end
         else
            if cb > dist then
               cb = dist
               pos.dist = dist
               pos.play = true
               pos.proj = false
            else
               pos.x = ox
               pos.y = oy
            end
         end
      end
   end
   
   for i = 1, #self.projectiles do
      if not b and self.projectiles[i].owner ~= self.p.id then
      local velX,velY = self.projectiles[i].physics.body:getLinearVelocity()
      local ox = pos.x
      local oy = pos.y
      local ax = self.projectiles[i].trans.x + velX/10
      local ay = self.projectiles[i].trans.y + velY/10
      local x1 = ax - w
      local x2 = ax
      local x3 = ax + w
      local y1 = ay - h
      local y2 = ay
      local y3 = ay + h
         if math.abs(px - x2) < math.abs(px - x3) then
            if math.abs(px - x1) < math.abs(px - x2) then
               pos.x = x1
            else
               pos.x = x2
            end
         else
            pos.x = x3
         end
         
         if math.abs(py - y2) < math.abs(py - y3) then
            if math.abs(py - y1) < math.abs(py - y2) then
               pos.y = y1
            else
               pos.y = y2
            end
         else
            pos.y = y3
         end
         
         local dist = math.sqrt(math.pow(px - pos.x,2)+math.pow(py - pos.y,2))
         if cb > dist + 50 and dist < 300 then
            cb = dist + 50
            pos.dist = dist
            pos.play = false
            pos.proj = true
         else
            pos.x = ox
            pos.y = oy
         end
      end
   end
   
   return pos
end

return AIController
