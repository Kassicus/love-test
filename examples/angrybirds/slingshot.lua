-- examples/angrybirds/slingshot.lua - Slingshot class

local Slingshot = {}
Slingshot.__index = Slingshot

function Slingshot.new(x, y, world)
    local self = setmetatable({}, Slingshot)
    
    self.x = x
    self.y = y
    self.world = world
    self.baseX = x
    self.baseY = y
    
    return self
end

function Slingshot:update(dt)
    -- Slingshot doesn't need much updating
end

function Slingshot:getX()
    return self.x
end

function Slingshot:getY()
    return self.y
end

function Slingshot:reset()
    self.x = self.baseX
    self.y = self.baseY
end

function Slingshot:draw()
    -- Draw slingshot base
    love.graphics.setColor(0.4, 0.2, 0.1, 1) -- Brown
    love.graphics.rectangle('fill', self.x - 10, self.y - 20, 20, 40)
    
    -- Draw slingshot arms
    love.graphics.setColor(0.3, 0.15, 0.05, 1) -- Darker brown
    love.graphics.rectangle('fill', self.x - 15, self.y - 30, 5, 20)
    love.graphics.rectangle('fill', self.x + 10, self.y - 30, 5, 20)
    
    -- Draw slingshot band (rubber band)
    love.graphics.setColor(0.2, 0.2, 0.2, 1) -- Dark gray
    love.graphics.setLineWidth(3)
    love.graphics.line(self.x - 12, self.y - 20, self.x - 5, self.y - 10)
    love.graphics.line(self.x + 12, self.y - 20, self.x + 5, self.y - 10)
    love.graphics.setLineWidth(1)
    
    -- Draw slingshot base shadow
    love.graphics.setColor(0.2, 0.1, 0.05, 1)
    love.graphics.ellipse('fill', self.x, self.y + 25, 15, 5)
end

return Slingshot 