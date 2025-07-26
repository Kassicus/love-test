-- examples/snake/food.lua - Food class

local Food = {}
Food.__index = Food

function Food.new(gridSize, cellSize)
    local self = setmetatable({}, Food)
    
    self.gridSize = gridSize
    self.cellSize = cellSize
    self.x = 0
    self.y = 0
    
    return self
end

function Food:randomizePosition(snakeBody)
    local attempts = 0
    local maxAttempts = 100
    
    repeat
        self.x = math.random(0, self.gridSize - 1)
        self.y = math.random(0, self.gridSize - 1)
        attempts = attempts + 1
    until not self:isOnSnake(snakeBody) or attempts >= maxAttempts
    
    -- If we can't find a good position, just place it anywhere
    if attempts >= maxAttempts then
        self.x = math.random(0, self.gridSize - 1)
        self.y = math.random(0, self.gridSize - 1)
    end
end

function Food:isOnSnake(snakeBody)
    for _, segment in ipairs(snakeBody) do
        if self.x == segment.x and self.y == segment.y then
            return true
        end
    end
    return false
end

function Food:draw()
    local x = 50 + self.x * self.cellSize
    local y = 50 + self.y * self.cellSize
    
    -- Draw food as a red circle
    love.graphics.setColor(0.8, 0.2, 0.2, 1)
    love.graphics.circle('fill', x + self.cellSize/2, y + self.cellSize/2, self.cellSize/2 - 2)
    
    -- Draw border
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.circle('line', x + self.cellSize/2, y + self.cellSize/2, self.cellSize/2 - 2)
end

return Food 