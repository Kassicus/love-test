-- examples/snake/main.lua - Snake game clone

-- Import modules
local Snake = require('snake')
local Food = require('food')
local GameState = require('gameState')

-- Game variables
local snake = nil
local food = nil
local gameState = nil
local gridSize = 20
local cellSize = 25

function love.load()
    -- Set window properties
    love.window.setTitle("Snake Game")
    love.window.setMode(800, 600)
    
    -- Initialize game objects
    gameState = GameState.new()
    snake = Snake.new(10, 10, gridSize, cellSize)
    food = Food.new(gridSize, cellSize)
    
    -- Set initial food position
    food:randomizePosition(snake:getBody())
    
    -- Set default font
    love.graphics.setFont(love.graphics.newFont(16))
end

function love.update(dt)
    if gameState:isPlaying() then
        -- Update snake movement
        snake:update(dt)
        
        -- Check for food collision
        if snake:getHead().x == food.x and snake:getHead().y == food.y then
            snake:grow()
            food:randomizePosition(snake:getBody())
            gameState:addScore(10)
        end
        
        -- Check for wall collision
        local head = snake:getHead()
        if head.x < 0 or head.x >= gridSize or head.y < 0 or head.y >= gridSize then
            gameState:gameOver()
        end
        
        -- Check for self collision
        if snake:checkSelfCollision() then
            gameState:gameOver()
        end
    end
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw game area border
    love.graphics.setColor(0.3, 0.3, 0.4, 1)
    love.graphics.rectangle('line', 50, 50, gridSize * cellSize, gridSize * cellSize)
    
    -- Draw snake
    snake:draw()
    
    -- Draw food
    food:draw()
    
    -- Draw UI
    drawUI()
end

function love.keypressed(key)
    if gameState:isPlaying() then
        -- Handle snake direction changes
        if key == 'up' or key == 'w' then
            snake:setDirection(0, -1)
        elseif key == 'down' or key == 's' then
            snake:setDirection(0, 1)
        elseif key == 'left' or key == 'a' then
            snake:setDirection(-1, 0)
        elseif key == 'right' or key == 'd' then
            snake:setDirection(1, 0)
        end
    end
    
    -- Handle game state changes
    if key == 'space' then
        if gameState:isGameOver() then
            gameState:restart()
            snake:reset(10, 10)
            food:randomizePosition(snake:getBody())
        end
    elseif key == 'escape' then
        love.event.quit()
    end
end

function drawUI()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw score
    love.graphics.print("Score: " .. gameState:getScore(), 10, 10)
    
    -- Draw game state messages
    if gameState:isGameOver() then
        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.print("GAME OVER!", 300, 250)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press SPACE to restart", 280, 280)
        love.graphics.print("Press ESC to quit", 290, 310)
    end
    
    -- Draw controls
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print("Controls: WASD or Arrow Keys", 10, 570)
end 