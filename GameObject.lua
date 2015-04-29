local class = require 'middleclass/middleclass'

local GameObject = class('GameObject')

function GameObject:initialize(id, gs)
	self.gs = gs
	self.id = id

	self.att = {}
	self.drawList = {}
	self.trans = nil
	self.controller = nil
	self.physics = nil
	self.graphics = nil
	self.collision = nil
	self.exit = nil
	self.components = {}
end

function GameObject:update()
	if self.controller ~= nil then
		--self.controller:update(self)
	end

	if self.physics ~= nil then
		self.physics:update() 
	end

	if #self.components > 0 then
		for i = 1,#self.components do 
			self.components[i]:update()
		end
	end
end

function GameObject:draw()

	for i = #self.drawList, 1,-1 do
		self.drawList[i]:draw()
	end
end

function GameObject:addComponent(comp)
	if comp:getType() == 'Transformation' then
		self.trans = comp
		return
	end

	if comp:getType() == 'Collision' then
		self.collision = comp
		return
	end

	if comp:getType() == 'Exit' then
		self.exit = comp
		return
	end

	if comp:getType() == 'Physics' then
		self.physics = comp
		return
	end

	if comp:getType() == 'Graphics' then
		self.graphics = comp
		table.insert(self.drawList,comp)
		return
	end

	if comp:getType() == 'Controller' then
		self.controller = comp
		return
	end

	if comp:getType() == 'Effect' then
		table.insert(self.drawList,comp)
	end

	table.insert(self.components, comp)
end

return GameObject
