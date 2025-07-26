-- src/player.lua - Player module for the game

local Player = {}
Player.__index = Player

-- Player constructor
function Player.new(x, y)
    local self = setmetatable({}, Player)
    
    self.x = x or 400
    self.y = y or 300
    self.size = 20
    self.speed = 200
    self.color = {0.8, 0.6, 0.9, 1}
    
    return self
end

-- Update player position based on input
function Player:update(dt)
    -- Handle movement input
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.y = self.y + self.speed * dt
    end
    
    -- Keep player within screen bounds
    self.x = math.max(self.size, math.min(love.graphics.getWidth() - self.size, self.x))
    self.y = math.max(self.size, math.min(love.graphics.getHeight() - self.size, self.y))
end

-- Draw the player
function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.size)
    
    -- Draw a border
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle('line', self.x, self.y, self.size)
end

-- Get player position
function Player:getPosition()
    return self.x, self.y
end

-- Set player position
function Player:setPosition(x, y)
    self.x = x
    self.y = y
end

return Player 