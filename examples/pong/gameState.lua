-- examples/pong/gameState.lua - Game state management

local GameState = {}
GameState.__index = GameState

-- Game states
local STATES = {
    WAITING = "waiting",
    PLAYING = "playing",
    GAME_OVER = "game_over"
}

function GameState.new()
    local self = setmetatable({}, GameState)
    
    self.state = STATES.WAITING
    self.playerScore = 0
    self.aiScore = 0
    self.winningScore = 11 -- First to 11 wins
    
    return self
end

function GameState:isWaiting()
    return self.state == STATES.WAITING
end

function GameState:isPlaying()
    return self.state == STATES.PLAYING
end

function GameState:isGameOver()
    return self.state == STATES.GAME_OVER
end

function GameState:startPlaying()
    self.state = STATES.PLAYING
end

function GameState:playerScores()
    self.playerScore = self.playerScore + 1
    self:checkWinCondition()
end

function GameState:aiScores()
    self.aiScore = self.aiScore + 1
    self:checkWinCondition()
end

function GameState:checkWinCondition()
    if self.playerScore >= self.winningScore or self.aiScore >= self.winningScore then
        self.state = STATES.GAME_OVER
    else
        self.state = STATES.WAITING
    end
end

function GameState:restart()
    self.state = STATES.WAITING
    self.playerScore = 0
    self.aiScore = 0
end

function GameState:getPlayerScore()
    return self.playerScore
end

function GameState:getAiScore()
    return self.aiScore
end

function GameState:getWinner()
    if self.playerScore >= self.winningScore then
        return "Player"
    elseif self.aiScore >= self.winningScore then
        return "AI"
    else
        return nil
    end
end

return GameState 