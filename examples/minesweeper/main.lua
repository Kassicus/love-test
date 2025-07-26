-- examples/minesweeper/main.lua - Minesweeper game clone

-- Import modules
local Board = require('board')
local GameState = require('gameState')

-- Game variables
local board = nil
local gameState = nil
local cellSize = 30
local boardWidth = 16
local boardHeight = 16
local mineCount = 40
local debugMode = false -- Set to true to show debug info

function love.load()
    -- Set window properties
    love.window.setTitle("Minesweeper")
    love.window.setMode(boardWidth * cellSize + 40, boardHeight * cellSize + 100)
    
    -- Initialize game objects
    gameState = GameState.new()
    board = Board.new(boardWidth, boardHeight, mineCount, cellSize)
    
    -- Set default font
    love.graphics.setFont(love.graphics.newFont(16))
end

function love.update(dt)
    -- Game logic updates if needed
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.2, 0.2, 0.3, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw board
    board:draw()
    
    -- Draw UI
    drawUI()
    
    -- Draw debug info if enabled
    if debugMode then
        drawDebugInfo()
    end
end

function love.mousepressed(x, y, button)
    if gameState:isPlaying() then
        local gridX, gridY = screenToGrid(x, y)
        
        if gridX >= 1 and gridX <= boardWidth and gridY >= 1 and gridY <= boardHeight then
            if button == 1 then
                -- Left click - reveal cell
                local result = board:revealCell(gridX, gridY)
                if result == "mine" then
                    gameState:gameOver()
                    board:revealAllMines()
                elseif result == "win" then
                    gameState:win()
                    board:flagAllMines()
                end
            elseif button == 2 or button == 3 then
                -- Right click (button 2) or middle click (button 3) - flag cell
                -- On macOS, right-click might be button 2 or 3
                board:toggleFlag(gridX, gridY)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        gameState:restart()
        board:reset()
    elseif key == 'd' then
        -- Toggle debug mode
        debugMode = not debugMode
    end
end

function screenToGrid(screenX, screenY)
    local boardX = 20
    local boardY = 60
    
    -- Convert to 1-based grid coordinates to match board indexing
    local gridX = math.floor((screenX - boardX) / cellSize) + 1
    local gridY = math.floor((screenY - boardY) / cellSize) + 1
    
    return gridX, gridY
end

function drawUI()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw title
    love.graphics.print("Minesweeper", 20, 20)
    
    -- Draw mine counter
    local remainingMines = board:getRemainingMines()
    love.graphics.print("Mines: " .. remainingMines, 20, 40)
    
    -- Draw timer
    local time = gameState:getTime()
    love.graphics.print("Time: " .. time, love.graphics.getWidth() - 120, 40)
    
    -- Draw game state messages
    if gameState:isGameOver() then
        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.print("GAME OVER!", love.graphics.getWidth()/2 - 60, 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press R to restart", love.graphics.getWidth()/2 - 70, 40)
    elseif gameState:isWon() then
        love.graphics.setColor(0.5, 1, 0.5, 1)
        love.graphics.print("YOU WIN!", love.graphics.getWidth()/2 - 50, 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press R to restart", love.graphics.getWidth()/2 - 70, 40)
    end
    
    -- Draw controls
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print("Left Click: Reveal | Right Click: Flag | R: Restart | D: Debug", 20, love.graphics.getHeight() - 30)
end

function drawDebugInfo()
    local mouseX, mouseY = love.mouse.getPosition()
    local gridX, gridY = screenToGrid(mouseX, mouseY)
    
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print("Mouse: (" .. mouseX .. ", " .. mouseY .. ")", 10, love.graphics.getHeight() - 60)
    love.graphics.print("Grid: (" .. gridX .. ", " .. gridY .. ")", 10, love.graphics.getHeight() - 40)
    
    -- Highlight the cell under mouse
    if gridX >= 1 and gridX <= boardWidth and gridY >= 1 and gridY <= boardHeight then
        local boardX = 20
        local boardY = 60
        local screenX = boardX + (gridX - 1) * cellSize
        local screenY = boardY + (gridY - 1) * cellSize
        
        love.graphics.setColor(1, 1, 0, 0.3)
        love.graphics.rectangle('fill', screenX, screenY, cellSize - 1, cellSize - 1)
    end
end 