-- examples/blackjack/player.lua - Player module for managing player hands and betting

local Card = require('card')

local Player = {}
Player.__index = Player

-- Player constructor
function Player.new()
    local self = setmetatable({}, Player)
    
    self.hands = {{}} -- Array of hands (for splits)
    self.currentHand = 1
    self.bet = 0
    self.insuranceBet = 0
    self.bankroll = 1000 -- Starting bankroll
    self.totalWinnings = 0
    self.handsWon = 0
    self.handsLost = 0
    self.handsPushed = 0
    
    return self
end

-- Add a card to the current hand
function Player:addCard(card)
    if self.hands[self.currentHand] then
        table.insert(self.hands[self.currentHand], card)
        print("Added card to hand " .. self.currentHand .. ": " .. card:toString())
    end
end

-- Get the current hand
function Player:getCurrentHand()
    return self.hands[self.currentHand]
end

-- Get all hands
function Player:getHands()
    return self.hands
end

-- Get hand value (with Ace adjustment)
function Player:getHandValue(handIndex)
    handIndex = handIndex or self.currentHand
    local hand = self.hands[handIndex]
    if not hand then return 0 end
    
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

-- Check if hand has blackjack
function Player:hasBlackjack(handIndex)
    handIndex = handIndex or self.currentHand
    local hand = self.hands[handIndex]
    if not hand or #hand ~= 2 then return false end
    
    return self:getHandValue(handIndex) == 21
end

-- Check if hand is bust
function Player:isBust(handIndex)
    handIndex = handIndex or self.currentHand
    return self:getHandValue(handIndex) > 21
end

-- Check if hand can be doubled
function Player:canDouble(handIndex)
    handIndex = handIndex or self.currentHand
    local hand = self.hands[handIndex]
    if not hand or #hand ~= 2 then return false end
    
    return self.bankroll >= self.bet
end

-- Check if hand can be split
function Player:canSplit(handIndex)
    handIndex = handIndex or self.currentHand
    local hand = self.hands[handIndex]
    if not hand or #hand ~= 2 then return false end
    
    -- Check if cards have same value
    local card1 = hand[1]
    local card2 = hand[2]
    if not card1 or not card2 then return false end
    
    local value1 = card1:getValue()
    local value2 = card2:getValue()
    
    -- Handle Aces specially
    if card1:isAce() and card2:isAce() then
        return self.bankroll >= self.bet
    end
    
    return value1 == value2 and self.bankroll >= self.bet
end

-- Check if hand can surrender
function Player:canSurrender(handIndex)
    handIndex = handIndex or self.currentHand
    local hand = self.hands[handIndex]
    if not hand or #hand ~= 2 then return false end
    
    return true -- Can surrender on first two cards
end

-- Double down
function Player:doubleBet()
    if self:canDouble() then
        self.bankroll = self.bankroll - self.bet
        self.bet = self.bet * 2
        print("Player doubled bet to " .. self.bet)
    end
end

-- Split hand
function Player:splitHand()
    if not self:canSplit() then return false end
    
    local currentHand = self.hands[self.currentHand]
    if #currentHand ~= 2 then return false end
    
    -- Create new hand with second card
    local newHand = {currentHand[2]}
    table.insert(self.hands, newHand)
    
    -- Keep first card in current hand
    currentHand[2] = nil
    
    -- Deduct bet for new hand
    self.bankroll = self.bankroll - self.bet
    
    print("Split hand into " .. #self.hands .. " hands")
    return true
end

-- Surrender hand
function Player:surrender()
    if self:canSurrender() then
        self.bankroll = self.bankroll + (self.bet / 2)
        self.bet = 0
        print("Player surrendered, returned half bet")
    end
end

-- Take insurance
function Player:takeInsurance()
    if self.bankroll >= self.bet / 2 then
        self.insuranceBet = self.bet / 2
        self.bankroll = self.bankroll - self.insuranceBet
        print("Player took insurance for " .. self.insuranceBet)
    end
end

-- Place bet
function Player:placeBet(amount)
    if amount <= self.bankroll and amount > 0 then
        self.bet = amount
        self.bankroll = self.bankroll - amount
        print("Player bet " .. amount)
        return true
    end
    return false
end

-- Win hand
function Player:winHand(handIndex, multiplier)
    handIndex = handIndex or self.currentHand
    multiplier = multiplier or 1
    
    local winnings = self.bet * multiplier
    self.bankroll = self.bankroll + winnings + self.bet
    self.totalWinnings = self.totalWinnings + winnings
    self.handsWon = self.handsWon + 1
    
    print("Player won " .. winnings .. " on hand " .. handIndex)
end

-- Lose hand
function Player:loseHand(handIndex)
    handIndex = handIndex or self.currentHand
    self.handsLost = self.handsLost + 1
    print("Player lost hand " .. handIndex)
end

-- Push hand
function Player:pushHand(handIndex)
    handIndex = handIndex or self.currentHand
    self.bankroll = self.bankroll + self.bet
    self.handsPushed = self.handsPushed + 1
    print("Player pushed hand " .. handIndex)
end

-- Win insurance
function Player:winInsurance()
    if self.insuranceBet > 0 then
        local winnings = self.insuranceBet * 2
        self.bankroll = self.bankroll + winnings
        self.totalWinnings = self.totalWinnings + self.insuranceBet
        print("Player won insurance: " .. winnings)
    end
    self.insuranceBet = 0
end

-- Lose insurance
function Player:loseInsurance()
    self.insuranceBet = 0
    print("Player lost insurance")
end

-- Move to next hand (for splits)
function Player:nextHand()
    if self.currentHand < #self.hands then
        self.currentHand = self.currentHand + 1
        print("Moving to hand " .. self.currentHand)
        return true
    end
    return false
end

-- Clear hands for new hand (preserve bet)
function Player:clearHands()
    self.hands = {{}}
    self.currentHand = 1
    self.insuranceBet = 0
    print("Player hands cleared for new hand")
end

-- Reset for new round
function Player:reset()
    self.hands = {{}}
    self.currentHand = 1
    self.bet = 0
    self.insuranceBet = 0
    print("Player reset for new round")
end

-- Get current bet
function Player:getBet()
    return self.bet
end

-- Get bankroll
function Player:getBankroll()
    return self.bankroll
end

-- Get total winnings
function Player:getTotalWinnings()
    return self.totalWinnings
end

-- Get win rate
function Player:getWinRate()
    local totalHands = self.handsWon + self.handsLost + self.handsPushed
    if totalHands == 0 then return 0 end
    return (self.handsWon / totalHands) * 100
end

-- Draw the player's hands
function Player:draw(x, y)
    local cardWidth = 80
    local cardHeight = 120
    local cardSpacing = 15
    
    for handIndex, hand in ipairs(self.hands) do
        local handX = x + (handIndex - 1) * (cardWidth + cardSpacing) * 3
        local handY = y
        
        -- Draw hand label
        love.graphics.setColor(1, 1, 1, 1)
        local label = "Hand " .. handIndex
        if handIndex == self.currentHand then
            label = label .. " (Current)"
        end
        love.graphics.print(label, handX, handY - 35)
        
        -- Draw hand value
        local value = self:getHandValue(handIndex)
        local valueColor = {1, 1, 1, 1}
        if value > 21 then
            valueColor = {1, 0.3, 0.3, 1} -- Red for bust
        elseif value == 21 then
            valueColor = {0.3, 1, 0.3, 1} -- Green for 21
        end
        love.graphics.setColor(valueColor)
        love.graphics.print("Value: " .. value, handX, handY - 15)
        
        -- Draw cards
        for cardIndex, card in ipairs(hand) do
            local cardX = handX + (cardIndex - 1) * (cardWidth + 8)
            card:draw(cardX, handY, cardWidth, cardHeight)
        end
    end
    
    -- Draw betting info (only if there are cards)
    if #self.hands[1] > 0 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Bet: $" .. self.bet, x, y + cardHeight + 30)
        if self.insuranceBet > 0 then
            love.graphics.print("Insurance: $" .. self.insuranceBet, x, y + cardHeight + 60)
        end
    end
end

return Player 