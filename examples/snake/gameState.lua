-- examples/snake/gameState.lua - Game state management

local GameState = {}
GameState.__index = GameState

-- Game states
local STATES = {
    PLAYING = "playing",
    GAME_OVER = "game_over"
}

function GameState.new()
    local self = setmetatable({}, GameState)
    
    self.state = STATES.PLAYING
    self.score = 0
    
    return self
end

function GameState:isPlaying()
    return self.state == STATES.PLAYING
end

function GameState:isGameOver()
    return self.state == STATES.GAME_OVER
end

function GameState:gameOver()
    self.state = STATES.GAME_OVER
end

function GameState:restart()
    self.state = STATES.PLAYING
    self.score = 0
end

function GameState:addScore(points)
    self.score = self.score + points
end

function GameState:getScore()
    return self.score
end

return GameState 