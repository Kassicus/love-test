-- examples/blackjack/dealer.lua - Dealer module for managing dealer hands and AI

local Card = require('card')

local Dealer = {}
Dealer.__index = Dealer

-- Dealer constructor
function Dealer.new()
    local self = setmetatable({}, Dealer)
    
    self.hand = {}
    self.holeCard = nil -- Face down card
    self.holeCardRevealed = false
    
    return self
end

-- Add a card to dealer's hand
function Dealer:addCard(card)
    table.insert(self.hand, card)
    print("Dealer received: " .. card:toString())
end

-- Add a card face down (hole card)
function Dealer:addCardFaceDown(card)
    self.holeCard = card
    card:setFaceUp(false)
    print("Dealer received hole card: " .. card:toString())
end

-- Reveal the hole card
function Dealer:revealHoleCard()
    if self.holeCard and not self.holeCardRevealed then
        self.holeCard:setFaceUp(true)
        table.insert(self.hand, self.holeCard)
        self.holeCard = nil
        self.holeCardRevealed = true
        print("Dealer revealed hole card: " .. self.hand[#self.hand]:toString())
    end
end

-- Get dealer's hand
function Dealer:getHand()
    return self.hand
end

-- Get hand value (with Ace adjustment)
function Dealer:getHandValue()
    local value = 0
    local aces = 0
    
    for _, card in ipairs(self.hand) do
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

-- Get visible hand value (excluding hole card)
function Dealer:getVisibleHandValue()
    local value = 0
    local aces = 0
    
    for _, card in ipairs(self.hand) do
        if card:isFaceUp() then
            if card:isAce() then
                aces = aces + 1
                value = value + 11
            else
                value = value + card:getValue()
            end
        end
    end
    
    -- Adjust Aces from 11 to 1 if needed
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end
    
    return value
end

-- Check if dealer has blackjack
function Dealer:hasBlackjack()
    if #self.hand ~= 2 then return false end
    
    -- If hole card is not revealed, check visible card + hole card
    if self.holeCard then
        local visibleCard = self.hand[1]
        if visibleCard:isAce() and self.holeCard:isTenCard() then
            return true
        elseif visibleCard:isTenCard() and self.holeCard:isAce() then
            return true
        end
    else
        return self:getHandValue() == 21
    end
    
    return false
end

-- Check if dealer shows Ace (for insurance)
function Dealer:showsAce()
    if #self.hand > 0 then
        return self.hand[1]:isAce()
    end
    return false
end

-- Check if dealer shows 10-value card
function Dealer:showsTenCard()
    if #self.hand > 0 then
        return self.hand[1]:isTenCard()
    end
    return false
end

-- Check if dealer should hit (standard casino rules)
function Dealer:shouldHit()
    local value = self:getHandValue()
    return value < 17
end

-- Check if dealer should hit soft 17
function Dealer:shouldHitSoft17()
    local value = self:getHandValue()
    if value >= 17 then return false end
    
    -- Check if it's a soft 17 (has Ace counted as 11)
    local hasAce = false
    local baseValue = 0
    
    for _, card in ipairs(self.hand) do
        if card:isAce() then
            hasAce = true
            baseValue = baseValue + 1
        else
            baseValue = baseValue + card:getValue()
        end
    end
    
    -- If we have an Ace and base value + 11 = 17, it's a soft 17
    if hasAce and baseValue + 10 == 17 then
        return true -- Hit soft 17
    end
    
    return value < 17
end

-- Check if dealer is bust
function Dealer:isBust()
    return self:getHandValue() > 21
end

-- Clear dealer hand for new hand
function Dealer:clearHand()
    self.hand = {}
    self.holeCard = nil
    self.holeCardRevealed = false
    print("Dealer hand cleared for new hand")
end

-- Reset dealer for new hand
function Dealer:reset()
    self.hand = {}
    self.holeCard = nil
    self.holeCardRevealed = false
    print("Dealer reset for new hand")
end

-- Draw dealer's hand
function Dealer:draw(x, y)
    local cardWidth = 80
    local cardHeight = 120
    local cardSpacing = 15
    
    -- Draw dealer label
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Dealer", x, y - 35)
    
    -- Draw hand value
    local value = self:getVisibleHandValue()
    if self.holeCardRevealed then
        value = self:getHandValue()
    end
    
    local valueColor = {1, 1, 1, 1}
    if value > 21 then
        valueColor = {1, 0.3, 0.3, 1} -- Red for bust
    elseif value == 21 then
        valueColor = {0.3, 1, 0.3, 1} -- Green for 21
    end
    
    love.graphics.setColor(valueColor)
    local valueText = "Value: " .. value
    if self.holeCard and not self.holeCardRevealed then
        valueText = valueText .. " + ?"
    end
    love.graphics.print(valueText, x, y - 15)
    
    -- Draw cards
    for cardIndex, card in ipairs(self.hand) do
        local cardX = x + (cardIndex - 1) * (cardWidth + cardSpacing)
        card:draw(cardX, y, cardWidth, cardHeight)
    end
    
    -- Draw hole card if not revealed
    if self.holeCard and not self.holeCardRevealed then
        local holeCardX = x + #self.hand * (cardWidth + cardSpacing)
        self.holeCard:draw(holeCardX, y, cardWidth, cardHeight)
    end
end

-- Get dealer's up card (first visible card)
function Dealer:getUpCard()
    if #self.hand > 0 then
        return self.hand[1]
    end
    return nil
end

-- Get dealer's hole card
function Dealer:getHoleCard()
    return self.holeCard
end

-- Check if hole card is revealed
function Dealer:isHoleCardRevealed()
    return self.holeCardRevealed
end

-- Get dealer's hand as string for logging
function Dealer:getHandString()
    local cards = {}
    for _, card in ipairs(self.hand) do
        table.insert(cards, card:toString())
    end
    if self.holeCard and not self.holeCardRevealed then
        table.insert(cards, "Face Down")
    end
    return table.concat(cards, ", ")
end

return Dealer 