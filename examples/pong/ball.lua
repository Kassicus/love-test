-- examples/pong/ball.lua - Ball class

local Ball = {}
Ball.__index = Ball

function Ball.new(x, y, size, speed)
    local self = setmetatable({}, Ball)
    
    self.x = x
    self.y = y
    self.size = size
    self.speed = speed
    self.velocityX = 0
    self.velocityY = 0
    self.isServed = false
    
    return self
end

function Ball:update(dt)
    if self.isServed then
        self.x = self.x + self.velocityX * dt
        self.y = self.y + self.velocityY * dt
        
        -- Bounce off top and bottom walls
        if self.y <= 0 or self.y + self.size >= love.graphics.getHeight() then
            self.velocityY = -self.velocityY
            self.y = math.max(0, math.min(love.graphics.getHeight() - self.size, self.y))
        end
    end
end

function Ball:serve()
    -- Serve the ball in a random direction
    local angle = math.random(-45, 45) * math.pi / 180
    local direction = math.random(0, 1) * 2 - 1 -- -1 or 1
    
    self.velocityX = direction * self.speed * math.cos(angle)
    self.velocityY = self.speed * math.sin(angle)
    self.isServed = true
end

function Ball:reset()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.velocityX = 0
    self.velocityY = 0
    self.isServed = false
end

function Ball:checkPaddleCollision(paddle)
    local paddleBounds = paddle:getBounds()
    
    -- Check if ball overlaps with paddle
    return self.x < paddleBounds.x + paddleBounds.width and
           self.x + self.size > paddleBounds.x and
           self.y < paddleBounds.y + paddleBounds.height and
           self.y + self.size > paddleBounds.y
end

function Ball:bounceOffPaddle(paddle)
    local paddleBounds = paddle:getBounds()
    local paddleCenter = paddleBounds.y + paddleBounds.height / 2
    local ballCenter = self.y + self.size / 2
    
    -- Calculate relative position of ball on paddle (-1 to 1)
    local relativeIntersectY = (ballCenter - paddleCenter) / (paddleBounds.height / 2)
    
    -- Bounce angle based on where ball hits paddle
    local bounceAngle = relativeIntersectY * math.pi / 3 -- Max 60 degrees
    
    -- Determine bounce direction based on which side of screen paddle is on
    if paddleBounds.x < love.graphics.getWidth() / 2 then
        -- Left paddle (player)
        self.velocityX = math.abs(self.velocityX)
    else
        -- Right paddle (AI)
        self.velocityX = -math.abs(self.velocityX)
    end
    
    -- Set Y velocity based on bounce angle
    self.velocityY = self.speed * math.sin(bounceAngle)
    
    -- Ensure minimum speed
    local currentSpeed = math.sqrt(self.velocityX^2 + self.velocityY^2)
    if currentSpeed < self.speed * 0.5 then
        local speedMultiplier = self.speed / currentSpeed
        self.velocityX = self.velocityX * speedMultiplier
        self.velocityY = self.velocityY * speedMultiplier
    end
    
    -- Prevent ball from getting stuck in paddle
    if paddleBounds.x < love.graphics.getWidth() / 2 then
        self.x = paddleBounds.x + paddleBounds.width
    else
        self.x = paddleBounds.x - self.size
    end
end

function Ball:getX()
    return self.x
end

function Ball:getY()
    return self.y
end

function Ball:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', self.x + self.size/2, self.y + self.size/2, self.size/2)
    
    -- Draw border
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.circle('line', self.x + self.size/2, self.y + self.size/2, self.size/2)
end

return Ball 