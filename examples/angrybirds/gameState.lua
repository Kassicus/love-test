-- examples/angrybirds/gameState.lua - Game state management

local GameState = {}
GameState.__index = GameState

-- Game states
local STATES = {
    PLAYING = "playing",
    WON = "won",
    LOST = "lost"
}

function GameState.new()
    local self = setmetatable({}, GameState)
    
    self.state = STATES.PLAYING
    self.currentBirdIndex = 1
    self.totalBirds = 5
    
    return self
end

function GameState:isPlaying()
    return self.state == STATES.PLAYING
end

function GameState:isWon()
    return self.state == STATES.WON
end

function GameState:isLost()
    return self.state == STATES.LOST
end

function GameState:nextBird()
    self.currentBirdIndex = self.currentBirdIndex + 1
end

function GameState:getCurrentBirdIndex()
    return self.currentBirdIndex
end

function GameState:getRemainingBirds()
    return math.max(0, self.totalBirds - self.currentBirdIndex + 1)
end

function GameState:win()
    self.state = STATES.WON
end

function GameState:lose()
    self.state = STATES.LOST
end

function GameState:restart()
    self.state = STATES.PLAYING
    self.currentBirdIndex = 1
end

return GameState 