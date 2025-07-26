-- examples/blackjack/solver.lua - Optimal blackjack strategy solver

local Solver = {}
Solver.__index = Solver

-- Basic strategy chart for hard hands (no Aces or pairs)
-- Rows: Player total (5-21), Columns: Dealer upcard (A, 2-10)
local HARD_STRATEGY = {
    -- Player 5-8: Always hit
    [5] = {"H", "H", "H", "H", "H", "H", "H", "H", "H", "H"},
    [6] = {"H", "H", "H", "H", "H", "H", "H", "H", "H", "H"},
    [7] = {"H", "H", "H", "H", "H", "H", "H", "H", "H", "H"},
    [8] = {"H", "H", "H", "H", "H", "H", "H", "H", "H", "H"},
    
    -- Player 9: Double vs 3-6, hit otherwise
    [9] = {"H", "H", "D", "D", "D", "D", "H", "H", "H", "H"},
    
    -- Player 10: Double vs 2-9, hit vs 10/A
    [10] = {"H", "D", "D", "D", "D", "D", "D", "D", "D", "H"},
    
    -- Player 11: Double vs 2-10, hit vs A
    [11] = {"H", "D", "D", "D", "D", "D", "D", "D", "D", "D"},
    
    -- Player 12: Stand vs 4-6, hit otherwise
    [12] = {"H", "H", "H", "S", "S", "S", "H", "H", "H", "H"},
    
    -- Player 13-16: Stand vs 2-6, hit vs 7-A
    [13] = {"H", "S", "S", "S", "S", "S", "H", "H", "H", "H"},
    [14] = {"H", "S", "S", "S", "S", "S", "H", "H", "H", "H"},
    [15] = {"H", "S", "S", "S", "S", "S", "H", "H", "H", "H"},
    [16] = {"H", "S", "S", "S", "S", "S", "H", "H", "H", "H"},
    
    -- Player 17-21: Always stand
    [17] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    [18] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    [19] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    [20] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    [21] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"}
}

-- Soft strategy chart (hands with Aces counted as 11)
-- Rows: Soft total (A,2 through A,9), Columns: Dealer upcard (A, 2-10)
local SOFT_STRATEGY = {
    -- A,2 (soft 13): Double vs 5-6, hit otherwise
    [13] = {"H", "H", "H", "H", "D", "D", "H", "H", "H", "H"},
    
    -- A,3 (soft 14): Double vs 5-6, hit otherwise
    [14] = {"H", "H", "H", "H", "D", "D", "H", "H", "H", "H"},
    
    -- A,4 (soft 15): Double vs 4-6, hit otherwise
    [15] = {"H", "H", "H", "D", "D", "D", "H", "H", "H", "H"},
    
    -- A,5 (soft 16): Double vs 4-6, hit otherwise
    [16] = {"H", "H", "H", "D", "D", "D", "H", "H", "H", "H"},
    
    -- A,6 (soft 17): Double vs 3-6, hit otherwise
    [17] = {"H", "H", "D", "D", "D", "D", "H", "H", "H", "H"},
    
    -- A,7 (soft 18): Stand vs 2,7,8, Double vs 3-6, Hit vs 9,10,A
    [18] = {"H", "S", "D", "D", "D", "D", "S", "S", "H", "H"},
    
    -- A,8 (soft 19): Always stand
    [19] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    
    -- A,9 (soft 20): Always stand
    [20] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"}
}

-- Pair splitting strategy
-- Rows: Pair value, Columns: Dealer upcard (A, 2-10)
local PAIR_STRATEGY = {
    -- A,A: Always split
    [11] = {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    
    -- 10,10: Never split
    [10] = {"S", "S", "S", "S", "S", "S", "S", "S", "S", "S"},
    
    -- 9,9: Split vs 2-9 except 7, stand vs 7,10,A
    [9] = {"S", "P", "P", "P", "P", "P", "S", "P", "P", "S"},
    
    -- 8,8: Always split
    [8] = {"P", "P", "P", "P", "P", "P", "P", "P", "P", "P"},
    
    -- 7,7: Split vs 2-7, hit vs 8-A
    [7] = {"H", "P", "P", "P", "P", "P", "P", "H", "H", "H"},
    
    -- 6,6: Split vs 2-6, hit vs 7-A
    [6] = {"H", "P", "P", "P", "P", "P", "H", "H", "H", "H"},
    
    -- 5,5: Never split (treat as 10)
    [5] = {"H", "D", "D", "D", "D", "D", "D", "D", "D", "H"},
    
    -- 4,4: Hit vs all (or split vs 5-6 in some variations)
    [4] = {"H", "H", "H", "H", "P", "P", "H", "H", "H", "H"},
    
    -- 3,3: Split vs 2-7, hit vs 8-A
    [3] = {"H", "P", "P", "P", "P", "P", "P", "H", "H", "H"},
    
    -- 2,2: Split vs 2-7, hit vs 8-A
    [2] = {"H", "P", "P", "P", "P", "P", "P", "H", "H", "H"}
}

-- Surrender strategy (late surrender)
-- Only applies to initial 2-card hands
local SURRENDER_STRATEGY = {
    [15] = {false, false, false, false, false, false, false, false, false, true}, -- Surrender vs 10
    [16] = {false, false, false, false, false, false, false, false, true, true}   -- Surrender vs 9,10
}

-- Insurance strategy (generally not recommended)
local INSURANCE_STRATEGY = false -- Never take insurance with basic strategy

function Solver.new()
    local self = setmetatable({}, Solver)
    return self
end

-- Convert dealer upcard to strategy table index (1-10)
function Solver:getDealerIndex(dealerCard)
    if dealerCard:isAce() then
        return 1 -- Ace is index 1
    elseif dealerCard:getValue() >= 10 then
        return 10 -- 10, J, Q, K are all index 10
    else
        return dealerCard:getValue() -- 2-9 are their face value
    end
end

-- Check if hand is a pair
function Solver:isPair(hand)
    if #hand ~= 2 then return false end
    
    local card1, card2 = hand[1], hand[2]
    
    -- Both Aces
    if card1:isAce() and card2:isAce() then
        return true, 11
    end
    
    -- Same face value
    if card1:getValue() == card2:getValue() then
        return true, card1:getValue()
    end
    
    return false, nil
end

-- Check if hand is soft (contains Ace counted as 11)
function Solver:isSoftHand(hand, totalValue)
    if totalValue > 21 then return false end
    
    local aces = 0
    local hardValue = 0
    
    for _, card in ipairs(hand) do
        if card:isAce() then
            aces = aces + 1
            hardValue = hardValue + 1
        else
            hardValue = hardValue + card:getValue()
        end
    end
    
    -- If we have aces and using one as 11 gives us the total value
    return aces > 0 and (hardValue + 10) == totalValue
end

-- Get optimal action for the current hand
function Solver:getOptimalAction(playerHand, dealerUpcard, canDouble, canSplit, canSurrender)
    if not playerHand or #playerHand == 0 or not dealerUpcard then
        return "H", "Invalid input"
    end
    
    local playerValue = self:calculateHandValue(playerHand)
    local dealerIndex = self:getDealerIndex(dealerUpcard)
    
    -- Check for bust (shouldn't happen in normal play)
    if playerValue > 21 then
        return "S", "Hand is bust"
    end
    
    -- Check for blackjack
    if #playerHand == 2 and playerValue == 21 then
        return "S", "Blackjack - stand"
    end
    
    -- Check surrender first (only on initial 2-card hands)
    if canSurrender and #playerHand == 2 and SURRENDER_STRATEGY[playerValue] then
        if SURRENDER_STRATEGY[playerValue][dealerIndex] then
            return "R", "Surrender is optimal"
        end
    end
    
    -- Check for pairs (only on initial 2-card hands)
    if canSplit and #playerHand == 2 then
        local isPair, pairValue = self:isPair(playerHand)
        if isPair and PAIR_STRATEGY[pairValue] then
            local action = PAIR_STRATEGY[pairValue][dealerIndex]
            if action == "P" then
                return "P", "Split pair of " .. (pairValue == 11 and "Aces" or pairValue .. "s")
            end
        end
    end
    
    -- Check for soft hands
    if self:isSoftHand(playerHand, playerValue) and SOFT_STRATEGY[playerValue] then
        local action = SOFT_STRATEGY[playerValue][dealerIndex]
        if action == "D" and canDouble then
            return "D", "Double soft " .. playerValue
        elseif action == "D" and not canDouble then
            return "H", "Hit (can't double soft " .. playerValue .. ")"
        elseif action == "S" then
            return "S", "Stand soft " .. playerValue
        else
            return "H", "Hit soft " .. playerValue
        end
    end
    
    -- Hard hands
    if HARD_STRATEGY[playerValue] then
        local action = HARD_STRATEGY[playerValue][dealerIndex]
        if action == "D" and canDouble then
            return "D", "Double hard " .. playerValue
        elseif action == "D" and not canDouble then
            return "H", "Hit (can't double hard " .. playerValue .. ")"
        elseif action == "S" then
            return "S", "Stand hard " .. playerValue
        else
            return "H", "Hit hard " .. playerValue
        end
    end
    
    -- Default fallback for values not in strategy table
    if playerValue >= 17 then
        return "S", "Stand on " .. playerValue
    else
        return "H", "Hit on " .. playerValue
    end
end

-- Calculate hand value (same logic as player module)
function Solver:calculateHandValue(hand)
    local value = 0
    local aces = 0
    
    for _, card in ipairs(hand) do
        if card:isAce() then
            aces = aces + 1
            value = value + 11
        else
            value = value + card:getValue()
        end
    end
    
    -- Adjust Aces from 11 to 1 if needed
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end
    
    return value
end

-- Check if insurance is recommended
function Solver:shouldTakeInsurance(playerHand, dealerUpcard)
    -- Basic strategy: never take insurance
    return false, "Insurance is not recommended with basic strategy"
end

-- Get action description for display
function Solver:getActionDescription(action)
    local descriptions = {
        H = "Hit",
        S = "Stand",
        D = "Double",
        P = "Split",
        R = "Surrender",
        I = "Take Insurance"
    }
    return descriptions[action] or "Unknown"
end

-- Get strategy explanation
function Solver:getStrategyExplanation(playerHand, dealerUpcard, action, reason)
    local playerValue = self:calculateHandValue(playerHand)
    local dealerCardName = dealerUpcard:isAce() and "Ace" or tostring(dealerUpcard:getValue())
    
    return string.format(
        "Player: %d vs Dealer: %s\nRecommended: %s (%s)\nReason: %s",
        playerValue,
        dealerCardName,
        self:getActionDescription(action),
        action,
        reason
    )
end

return Solver