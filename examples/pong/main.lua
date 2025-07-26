-- examples/pong/main.lua - Pong game clone

-- Import modules
local Paddle = require('paddle')
local Ball = require('ball')
local GameState = require('gameState')

-- Game variables
local playerPaddle = nil
local aiPaddle = nil
local ball = nil
local gameState = nil

-- Game constants
local PADDLE_WIDTH = 15
local PADDLE_HEIGHT = 80
local BALL_SIZE = 10
local PADDLE_SPEED = 300
local BALL_SPEED = 250

function love.load()
    -- Set window properties
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)
    
    -- Initialize game objects
    gameState = GameState.new()
    
    -- Create paddles
    playerPaddle = Paddle.new(50, 300, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED, "player")
    aiPaddle = Paddle.new(750, 300, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED, "ai")
    
    -- Create ball
    ball = Ball.new(400, 300, BALL_SIZE, BALL_SPEED)
    
    -- Set default font
    love.graphics.setFont(love.graphics.newFont(20))
end

function love.update(dt)
    if gameState:isPlaying() then
        -- Update paddles
        playerPaddle:update(dt)
        aiPaddle:update(dt, ball)
        
        -- Update ball
        ball:update(dt)
        
        -- Check paddle collisions
        checkPaddleCollisions()
        
        -- Check for scoring
        checkScoring()
        
        -- Keep paddles in bounds
        playerPaddle:keepInBounds(love.graphics.getHeight())
        aiPaddle:keepInBounds(love.graphics.getHeight())
    end
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw center line
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    for i = 0, love.graphics.getHeight(), 20 do
        love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 2, i, 4, 10)
    end
    
    -- Draw game objects
    playerPaddle:draw()
    aiPaddle:draw()
    ball:draw()
    
    -- Draw UI
    drawUI()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        if gameState:isGameOver() then
            gameState:restart()
            resetGame()
        elseif gameState:isWaiting() then
            gameState:startPlaying()
            ball:serve()
        end
    end
end

function checkPaddleCollisions()
    -- Player paddle collision
    if ball:checkPaddleCollision(playerPaddle) then
        ball:bounceOffPaddle(playerPaddle)
    end
    
    -- AI paddle collision
    if ball:checkPaddleCollision(aiPaddle) then
        ball:bounceOffPaddle(aiPaddle)
    end
end

function checkScoring()
    local ballX = ball:getX()
    
    -- Ball went past left side (AI scores)
    if ballX < 0 then
        gameState:aiScores()
        ball:reset()
    -- Ball went past right side (Player scores)
    elseif ballX > love.graphics.getWidth() then
        gameState:playerScores()
        ball:reset()
    end
end

function resetGame()
    playerPaddle:reset(50, 300)
    aiPaddle:reset(750, 300)
    ball:reset()
end

function drawUI()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw scores
    love.graphics.print("Player: " .. gameState:getPlayerScore(), 50, 20)
    love.graphics.print("AI: " .. gameState:getAiScore(), love.graphics.getWidth() - 100, 20)
    
    -- Draw game state messages
    if gameState:isWaiting() then
        love.graphics.print("Press SPACE to serve", 300, 250)
    elseif gameState:isGameOver() then
        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.print("GAME OVER!", 320, 250)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press SPACE to restart", 290, 280)
    end
    
    -- Draw controls
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print("Controls: W/S to move paddle", 10, 570)
end 