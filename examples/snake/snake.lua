-- examples/snake/snake.lua - Snake class

local Snake = {}
Snake.__index = Snake

function Snake.new(startX, startY, gridSize, cellSize)
    local self = setmetatable({}, Snake)
    
    self.gridSize = gridSize
    self.cellSize = cellSize
    self.moveTimer = 0
    self.moveInterval = 0.15 -- Move every 0.15 seconds
    
    -- Initialize snake body (head + 2 body segments)
    self.body = {
        {x = startX, y = startY},     -- Head
        {x = startX - 1, y = startY}, -- Body segment 1
        {x = startX - 2, y = startY}  -- Body segment 2
    }
    
    -- Initial direction (moving right)
    self.direction = {x = 1, y = 0}
    self.nextDirection = {x = 1, y = 0}
    
    return self
end

function Snake:update(dt)
    self.moveTimer = self.moveTimer + dt
    
    if self.moveTimer >= self.moveInterval then
        self.moveTimer = 0
        
        -- Update direction
        self.direction.x = self.nextDirection.x
        self.direction.y = self.nextDirection.y
        
        -- Move snake
        self:move()
    end
end

function Snake:move()
    -- Get current head position
    local head = self.body[1]
    
    -- Calculate new head position
    local newHead = {
        x = head.x + self.direction.x,
        y = head.y + self.direction.y
    }
    
    -- Insert new head at the beginning
    table.insert(self.body, 1, newHead)
    
    -- Remove tail (unless growing)
    if not self.growing then
        table.remove(self.body)
    else
        self.growing = false
    end
end

function Snake:setDirection(x, y)
    -- Prevent 180-degree turns (can't go directly opposite)
    if self.direction.x ~= -x or self.direction.y ~= -y then
        self.nextDirection.x = x
        self.nextDirection.y = y
    end
end

function Snake:grow()
    self.growing = true
end

function Snake:getHead()
    return self.body[1]
end

function Snake:getBody()
    return self.body
end

function Snake:checkSelfCollision()
    local head = self.body[1]
    
    -- Check if head collides with any body segment
    for i = 2, #self.body do
        if head.x == self.body[i].x and head.y == self.body[i].y then
            return true
        end
    end
    
    return false
end

function Snake:reset(startX, startY)
    self.body = {
        {x = startX, y = startY},     -- Head
        {x = startX - 1, y = startY}, -- Body segment 1
        {x = startX - 2, y = startY}  -- Body segment 2
    }
    self.direction = {x = 1, y = 0}
    self.nextDirection = {x = 1, y = 0}
    self.moveTimer = 0
    self.growing = false
end

function Snake:draw()
    -- Draw snake body
    for i, segment in ipairs(self.body) do
        local x = 50 + segment.x * self.cellSize
        local y = 50 + segment.y * self.cellSize
        
        if i == 1 then
            -- Draw head in different color
            love.graphics.setColor(0.2, 0.8, 0.2, 1)
        else
            -- Draw body segments
            love.graphics.setColor(0.1, 0.6, 0.1, 1)
        end
        
        love.graphics.rectangle('fill', x, y, self.cellSize - 1, self.cellSize - 1)
        
        -- Draw border
        love.graphics.setColor(0.3, 0.9, 0.3, 1)
        love.graphics.rectangle('line', x, y, self.cellSize - 1, self.cellSize - 1)
    end
end

return Snake 