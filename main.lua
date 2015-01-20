local class       = require 'middleclass'
local GameState   = require 'GameState'

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0

function love.load()
   local w,h = love.graphics.getDimensions()
   canvas = love.graphics.newCanvas(w,h)
   gs = GameState:new()
end


function love.update(dt)
   time.accum = time.accum + dt 

   while time.accum >= time.fdt do
      gs:update()

      if love.keyboard.isDown('escape') then
         love.event.quit()
      end
      time.accum = time.accum - time.fdt
   end

end

function love.draw()
   
   love.graphics.setCanvas(canvas)
   
   canvas:setFilter("nearest","nearest")
   canvas:clear()
   gs:draw()
    
   love.graphics.setCanvas()
   love.graphics.draw(canvas,0,0,0,1,1)

   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) 
end 
