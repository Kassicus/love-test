-- examples/blackjack/gameState.lua - Game state management for blackjack

local GameState = {}
GameState.__index = GameState

-- Game states
GameState.STATES = {
    WAITING_FOR_BET = "waiting_for_bet",
    DEALING = "dealing",
    PLAYER_TURN = "player_turn",
    INSURANCE_OFFERED = "insurance_offered",
    DEALER_TURN = "dealer_turn",
    GAME_OVER = "game_over"
}

-- Game results
GameState.RESULTS = {
    PLAYER_WIN = "player_win",
    DEALER_WIN = "dealer_win",
    PUSH = "push",
    PLAYER_BLACKJACK = "player_blackjack",
    DEALER_BLACKJACK = "dealer_blackjack",
    PLAYER_BUST = "player_bust",
    DEALER_BUST = "dealer_bust",
    PLAYER_SURRENDER = "player_surrender",
    INSURANCE_WIN = "insurance_win",
    INSURANCE_LOSE = "insurance_lose"
}

-- GameState constructor
function GameState.new()
    local self = setmetatable({}, GameState)
    
    self.currentState = GameState.STATES.WAITING_FOR_BET
    self.result = nil
    self.message = ""
    self.timer = 0
    self.autoAdvance = false
    
    -- Game statistics
    self.handsPlayed = 0
    self.playerWins = 0
    self.dealerWins = 0
    self.pushes = 0
    self.playerBlackjacks = 0
    self.dealerBlackjacks = 0
    
    return self
end

-- Update game state
function GameState:update(dt)
    self.timer = self.timer + dt
    
    -- Auto-advance after certain timeouts
    if self.autoAdvance and self.timer > 2.0 then
        self:advanceState()
    end
end

-- Check current state
function GameState:isWaitingForBet()
    return self.currentState == GameState.STATES.WAITING_FOR_BET
end

function GameState:isDealing()
    return self.currentState == GameState.STATES.DEALING
end

function GameState:isPlayerTurn()
    return self.currentState == GameState.STATES.PLAYER_TURN
end

function GameState:isInsuranceOffered()
    return self.currentState == GameState.STATES.INSURANCE_OFFERED
end

function GameState:isDealerTurn()
    return self.currentState == GameState.STATES.DEALER_TURN
end

function GameState:isGameOver()
    return self.currentState == GameState.STATES.GAME_OVER
end

-- State transitions
function GameState:startNewHand()
    self.currentState = GameState.STATES.DEALING
    self.result = nil
    self.message = "Dealing cards..."
    self.timer = 0
    self.autoAdvance = true
    print("Starting new hand")
end

function GameState:startPlayerTurn()
    self.currentState = GameState.STATES.PLAYER_TURN
    self.message = "Your turn - Hit (H), Stand (S), Double (D), Split (P), Surrender (R)"
    self.timer = 0
    self.autoAdvance = false
    print("Player turn started")
end

function GameState:offerInsurance()
    self.currentState = GameState.STATES.INSURANCE_OFFERED
    self.message = "Insurance offered - Take (I) or Decline (any other key)"
    self.timer = 0
    self.autoAdvance = false
    print("Insurance offered")
end

function GameState:insuranceTaken()
    self.message = "Insurance taken"
    self.timer = 0
    self.autoAdvance = true
end

function GameState:insuranceDeclined()
    self.message = "Insurance declined"
    self.timer = 0
    self.autoAdvance = true
end

function GameState:playerStand()
    self.currentState = GameState.STATES.DEALER_TURN
    self.message = "Dealer's turn..."
    self.timer = 0
    self.autoAdvance = true
    print("Player stands, dealer's turn")
end

function GameState:playerBust()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.PLAYER_BUST
    self.message = "BUST! You lose."
    self.timer = 0
    self.autoAdvance = true
    self.dealerWins = self.dealerWins + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Player busts")
end

function GameState:playerSurrendered()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.PLAYER_SURRENDER
    self.message = "Surrendered - Half bet returned"
    self.timer = 0
    self.autoAdvance = true
    self.dealerWins = self.dealerWins + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Player surrendered")
end

function GameState:playerBlackjack()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.PLAYER_BLACKJACK
    self.message = "BLACKJACK! You win 3:2!"
    self.timer = 0
    self.autoAdvance = true
    self.playerWins = self.playerWins + 1
    self.playerBlackjacks = self.playerBlackjacks + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Player blackjack")
end

function GameState:dealerBlackjack()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.DEALER_BLACKJACK
    self.message = "Dealer BLACKJACK! You lose."
    self.timer = 0
    self.autoAdvance = true
    self.dealerWins = self.dealerWins + 1
    self.dealerBlackjacks = self.dealerBlackjacks + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Dealer blackjack")
end

function GameState:dealerBust()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.DEALER_BUST
    self.message = "Dealer BUST! You win!"
    self.timer = 0
    self.autoAdvance = true
    self.playerWins = self.playerWins + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Dealer busts")
end

function GameState:playerWon()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.PLAYER_WIN
    self.message = "You win!"
    self.timer = 0
    self.autoAdvance = true
    self.playerWins = self.playerWins + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Player wins")
end

function GameState:dealerWon()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.DEALER_WIN
    self.message = "Dealer wins"
    self.timer = 0
    self.autoAdvance = true
    self.dealerWins = self.dealerWins + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Dealer wins")
end

function GameState:push()
    self.currentState = GameState.STATES.GAME_OVER
    self.result = GameState.RESULTS.PUSH
    self.message = "Push - Bet returned"
    self.timer = 0
    self.autoAdvance = true
    self.pushes = self.pushes + 1
    self.handsPlayed = self.handsPlayed + 1
    print("Push")
end

function GameState:resetForNewHand()
    self.currentState = GameState.STATES.WAITING_FOR_BET
    self.result = nil
    self.message = "Place your bet and press SPACE to deal"
    self.timer = 0
    self.autoAdvance = false
    print("Reset for new hand")
end

-- Advance state automatically
function GameState:advanceState()
    if self.currentState == GameState.STATES.DEALING then
        self:startPlayerTurn()
    elseif self.currentState == GameState.STATES.INSURANCE_OFFERED then
        self:insuranceDeclined()
        self:startPlayerTurn()
    elseif self.currentState == GameState.STATES.GAME_OVER then
        self:resetForNewHand()
    end
end

-- Get current state
function GameState:getCurrentState()
    return self.currentState
end

-- Get current message
function GameState:getMessage()
    return self.message
end

-- Get game result
function GameState:getResult()
    return self.result
end

-- Get game statistics
function GameState:getStats()
    return {
        handsPlayed = self.handsPlayed,
        playerWins = self.playerWins,
        dealerWins = self.dealerWins,
        pushes = self.pushes,
        playerBlackjacks = self.playerBlackjacks,
        dealerBlackjacks = self.dealerBlackjacks,
        playerWinRate = self.handsPlayed > 0 and (self.playerWins / self.handsPlayed) * 100 or 0,
        blackjackRate = self.handsPlayed > 0 and (self.playerBlackjacks / self.handsPlayed) * 100 or 0
    }
end

-- Get formatted statistics string
function GameState:getStatsString()
    local stats = self:getStats()
    return string.format(
        "Hands: %d | Wins: %d | Losses: %d | Pushes: %d | Win Rate: %.1f%% | Blackjacks: %d (%.1f%%)",
        stats.handsPlayed,
        stats.playerWins,
        stats.dealerWins,
        stats.pushes,
        stats.playerWinRate,
        stats.playerBlackjacks,
        stats.blackjackRate
    )
end

return GameState 