-- examples/blackjack/deck.lua - Deck module for managing a 6-deck shoe

local Card = require('card')

local Deck = {}
Deck.__index = Deck

-- Deck constructor
function Deck.new(numDecks)
    local self = setmetatable({}, Deck)
    
    self.numDecks = numDecks or 6
    self.cards = {}
    self.discardPile = {}
    
    self:initialize()
    self:shuffle()
    
    print("Created " .. self.numDecks .. "-deck shoe with " .. #self.cards .. " cards")
    return self
end

-- Initialize the deck with all cards
function Deck:initialize()
    self.cards = {}
    
    for deck = 1, self.numDecks do
        for _, suit in pairs(Card.SUITS) do
            for _, rank in pairs(Card.RANKS) do
                local card = Card.new(suit, rank)
                table.insert(self.cards, card)
            end
        end
    end
    
    print("Initialized " .. #self.cards .. " cards in " .. self.numDecks .. " decks")
end

-- Shuffle the deck using Fisher-Yates algorithm
function Deck:shuffle()
    local n = #self.cards
    for i = n, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
    
    print("Shuffled " .. #self.cards .. " cards")
end

-- Draw a card from the deck
function Deck:drawCard()
    if #self.cards == 0 then
        print("Deck is empty! Reshuffling...")
        self:reshuffle()
    end
    
    if #self.cards > 0 then
        local card = table.remove(self.cards)
        return card
    end
    
    return nil
end

-- Add a card to the discard pile
function Deck:discardCard(card)
    if card then
        table.insert(self.discardPile, card)
    end
end

-- Reshuffle the discard pile back into the deck
function Deck:reshuffle()
    -- Add all discarded cards back to the deck
    for _, card in ipairs(self.discardPile) do
        table.insert(self.cards, card)
    end
    
    self.discardPile = {}
    
    -- Shuffle the deck
    self:shuffle()
    
    print("Reshuffled " .. #self.cards .. " cards")
end

-- Get number of remaining cards
function Deck:getRemainingCards()
    return #self.cards
end

-- Get number of cards in discard pile
function Deck:getDiscardCount()
    return #self.discardPile
end

-- Check if deck needs reshuffling (when less than 25% of cards remain)
function Deck:needsReshuffle()
    local totalCards = self.numDecks * 52
    return #self.cards < totalCards * 0.25
end

-- Get deck penetration percentage
function Deck:getPenetration()
    local totalCards = self.numDecks * 52
    local remaining = #self.cards
    return ((totalCards - remaining) / totalCards) * 100
end

-- Draw the deck visualization
function Deck:draw(x, y)
    local cardWidth = 70
    local cardHeight = 105
    local maxVisible = 12
    
    -- Draw deck stack
    for i = 1, math.min(maxVisible, #self.cards) do
        local offset = (i - 1) * 2
        love.graphics.setColor(0.2, 0.2, 0.8, 1)
        love.graphics.rectangle('fill', x + offset, y + offset, cardWidth, cardHeight, 3, 3)
        love.graphics.setColor(0.1, 0.1, 0.4, 1)
        love.graphics.rectangle('line', x + offset, y + offset, cardWidth, cardHeight, 3, 3)
    end
    
    -- Draw card count
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(#self.cards, x + cardWidth/2 - 15, y + cardHeight + 8)
    
    -- Draw penetration indicator
    local penetration = self:getPenetration()
    local barWidth = 120
    local barHeight = 10
    local barX = x + cardWidth + 25
    local barY = y + cardHeight/2 - barHeight/2
    
    -- Background
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle('fill', barX, barY, barWidth, barHeight, 2, 2)
    
    -- Penetration level
    local fillWidth = (penetration / 100) * barWidth
    local color = {0.2, 0.8, 0.2, 1} -- Green
    if penetration > 75 then
        color = {0.8, 0.8, 0.2, 1} -- Yellow
    elseif penetration > 90 then
        color = {0.8, 0.2, 0.2, 1} -- Red
    end
    
    love.graphics.setColor(color)
    love.graphics.rectangle('fill', barX, barY, fillWidth, barHeight, 2, 2)
    
    -- Border
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', barX, barY, barWidth, barHeight, 2, 2)
    
    -- Penetration text
    love.graphics.print(string.format("%.1f%%", penetration), barX, barY - 18)
end

-- Get deck statistics for card counting
function Deck:getCardCount()
    local count = 0
    for _, card in ipairs(self.cards) do
        local value = card:getValue()
        if value >= 10 then
            count = count - 1 -- High cards
        elseif value <= 6 then
            count = count + 1 -- Low cards
        end
        -- 7, 8, 9 are neutral (0)
    end
    return count
end

-- Get true count (running count / decks remaining)
function Deck:getTrueCount()
    local runningCount = self:getCardCount()
    local decksRemaining = #self.cards / 52
    if decksRemaining > 0 then
        return runningCount / decksRemaining
    end
    return 0
end

return Deck 