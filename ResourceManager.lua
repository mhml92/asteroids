local class = require 'middleclass'
local ResourceManager = class('ResourceManager')

function ResourceManager:initialize(gs)
   self.img = {}
   self.gs = gs
end

function ResourceManager:loadImg(filename,handle)
   self.img[handle] =  love.graphics.newImage(filename)
   self.img[handle]:setFilter("nearest","nearest")
end

function ResourceManager:getImg(handle)
   return self.img[handle]
end

return ResourceManager
