-- examples/pong/paddle.lua - Paddle class

local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y, width, height, speed, type)
    local self = setmetatable({}, Paddle)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = speed
    self.type = type -- "player" or "ai"
    
    return self
end

function Paddle:update(dt, ball)
    if self.type == "player" then
        self:handlePlayerInput(dt)
    elseif self.type == "ai" then
        self:handleAIInput(dt, ball)
    end
end

function Paddle:handlePlayerInput(dt)
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        self.y = self.y + self.speed * dt
    end
end

function Paddle:handleAIInput(dt, ball)
    if not ball then return end
    
    local ballY = ball:getY()
    local paddleCenter = self.y + self.height / 2
    
    -- Simple AI: move towards the ball
    if ballY < paddleCenter - 10 then
        self.y = self.y - self.speed * dt
    elseif ballY > paddleCenter + 10 then
        self.y = self.y + self.speed * dt
    end
end

function Paddle:keepInBounds(screenHeight)
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > screenHeight then
        self.y = screenHeight - self.height
    end
end

function Paddle:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function Paddle:reset(x, y)
    self.x = x
    self.y = y
end

function Paddle:draw()
    -- Draw paddle with different colors for player vs AI
    if self.type == "player" then
        love.graphics.setColor(0.2, 0.8, 0.2, 1) -- Green for player
    else
        love.graphics.setColor(0.8, 0.2, 0.2, 1) -- Red for AI
    end
    
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    
    -- Draw border
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

return Paddle 