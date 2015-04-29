math.random = love.math.random

local class       = require 'middleclass/middleclass'
local GameState   = require 'GameState'

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0
local self = {}
function love.load()
	love.mouse.setVisible(false)
	local w,h = love.graphics.getDimensions()
	love.graphics.setScissor( 0, 0, w, h)

	self.gs = GameState:new()
end

function love.update(dt)
	time.accum = time.accum + dt 
	while time.accum >= time.fdt do
		self.gs:update(time.fdt)
		if love.keyboard.isDown('escape') then
			love.event.quit()
		end
		time.accum = time.accum - time.fdt
	end
end

function love.draw()
	self.gs:draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) 
end 

function beginContact(a,b,coll)
	self.gs:beginContact(a,b,coll)
end

function endContact(a,b,coll)
	self.gs:endContact(a,b,coll)
end

function preSolve(a,b,coll)
	self.gs:preSolve(a,b,coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	self.gs:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
