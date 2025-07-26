-- main.lua - Entry point for Love2D game
-- This file is required for any Love2D project

-- Import modules
local Player = require('src.player')
local UI = require('src.ui')

-- Game state variables
local gameState = {
    player = nil,
    colors = {
        background = {0.1, 0.1, 0.2, 1}
    }
}

-- Love2D callback functions

function love.load()
    -- Called once when the game starts
    print("Love2D game started!")
    
    -- Set window properties
    love.window.setTitle("Love2D Test Game")
    love.window.setMode(800, 600)
    
    -- Initialize game objects
    gameState.player = Player.new(400, 300)
    UI.init()
end

function love.update(dt)
    -- Called every frame to update game logic
    -- dt is delta time (time since last frame)
    
    -- Update player
    gameState.player:update(dt)
end

function love.draw()
    -- Called every frame to render graphics
    
    -- Clear screen with background color
    love.graphics.setColor(gameState.colors.background)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw player
    gameState.player:draw()
    
    -- Draw UI elements
    UI.drawInstructions()
    UI.drawPlayerPosition(gameState.player:getPosition())
    UI.drawFPS()
end

function love.keypressed(key)
    -- Called when a key is pressed
    if key == 'escape' then
        love.event.quit()
    end
end 