-- examples/minesweeper/gameState.lua - Game state management

local GameState = {}
GameState.__index = GameState

-- Game states
local STATES = {
    PLAYING = "playing",
    GAME_OVER = "game_over",
    WON = "won"
}

function GameState.new()
    local self = setmetatable({}, GameState)
    
    self.state = STATES.PLAYING
    self.startTime = love.timer.getTime()
    self.endTime = nil
    
    return self
end

function GameState:isPlaying()
    return self.state == STATES.PLAYING
end

function GameState:isGameOver()
    return self.state == STATES.GAME_OVER
end

function GameState:isWon()
    return self.state == STATES.WON
end

function GameState:gameOver()
    self.state = STATES.GAME_OVER
    self.endTime = love.timer.getTime()
end

function GameState:win()
    self.state = STATES.WON
    self.endTime = love.timer.getTime()
end

function GameState:restart()
    self.state = STATES.PLAYING
    self.startTime = love.timer.getTime()
    self.endTime = nil
end

function GameState:getTime()
    local endTime = self.endTime or love.timer.getTime()
    return math.floor(endTime - self.startTime)
end

return GameState 