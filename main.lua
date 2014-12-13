local class       = require 'middleclass'
local GameState   = require 'GameState'
local Utility     = require 'Utility'


function love.load()
   gs = GameState:new()
   --util = Utility:new()
end

function love.update(dt)
   
   gs:update()
   
   if love.keyboard.isDown('escape') then
      love.event.quit()
   end
end

function love.draw()
   gs:draw()
end 
