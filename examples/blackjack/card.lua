-- examples/blackjack/card.lua - Card module for representing playing cards

local Card = {}
Card.__index = Card

-- Card suits
Card.SUITS = {
    HEARTS = "hearts",
    DIAMONDS = "diamonds", 
    CLUBS = "clubs",
    SPADES = "spades"
}

-- Card ranks
Card.RANKS = {
    ACE = "A",
    TWO = "2",
    THREE = "3", 
    FOUR = "4",
    FIVE = "5",
    SIX = "6",
    SEVEN = "7",
    EIGHT = "8",
    NINE = "9",
    TEN = "10",
    JACK = "J",
    QUEEN = "Q",
    KING = "K"
}

-- Card constructor
function Card.new(suit, rank)
    local self = setmetatable({}, Card)
    
    self.suit = suit
    self.rank = rank
    self.faceUp = true
    
    return self
end

-- Get card value (Ace = 1 or 11, face cards = 10)
function Card:getValue()
    if self.rank == Card.RANKS.ACE then
        return 11 -- Will be adjusted in hand calculation
    elseif self.rank == Card.RANKS.JACK or 
           self.rank == Card.RANKS.QUEEN or 
           self.rank == Card.RANKS.KING then
        return 10
    else
        return tonumber(self.rank)
    end
end

-- Get card display value (for UI)
function Card:getDisplayValue()
    if self.rank == Card.RANKS.ACE then
        return "A"
    else
        return self.rank
    end
end

-- Check if card is an Ace
function Card:isAce()
    return self.rank == Card.RANKS.ACE
end

-- Check if card is a face card
function Card:isFaceCard()
    return self.rank == Card.RANKS.JACK or 
           self.rank == Card.RANKS.QUEEN or 
           self.rank == Card.RANKS.KING
end

-- Check if card is a 10-value card (for insurance)
function Card:isTenCard()
    return self.rank == Card.RANKS.TEN or 
           self.rank == Card.RANKS.JACK or 
           self.rank == Card.RANKS.QUEEN or 
           self.rank == Card.RANKS.KING
end

-- Get card color (red or black)
function Card:getColor()
    if self.suit == Card.SUITS.HEARTS or self.suit == Card.SUITS.DIAMONDS then
        return "red"
    else
        return "black"
    end
end

-- Get suit symbol
function Card:getSuitSymbol()
    local symbols = {
        [Card.SUITS.HEARTS] = "♥",
        [Card.SUITS.DIAMONDS] = "♦", 
        [Card.SUITS.CLUBS] = "♣",
        [Card.SUITS.SPADES] = "♠"
    }
    return symbols[self.suit] or "?"
end

-- Convert card to string
function Card:toString()
    if not self.faceUp then
        return "Face Down"
    end
    return self.rank .. self:getSuitSymbol()
end

-- Set card face up/down
function Card:setFaceUp(faceUp)
    self.faceUp = faceUp
end

-- Check if card is face up
function Card:isFaceUp()
    return self.faceUp
end

-- Draw the card
function Card:draw(x, y, width, height)
    width = width or 80
    height = height or 120
    
    if not self.faceUp then
        -- Draw card back
        love.graphics.setColor(0.2, 0.2, 0.8, 1)
        love.graphics.rectangle('fill', x, y, width, height, 5, 5)
        love.graphics.setColor(0.1, 0.1, 0.4, 1)
        love.graphics.rectangle('line', x, y, width, height, 5, 5)
        
        -- Draw pattern
        love.graphics.setColor(0.3, 0.3, 0.6, 1)
        for i = 0, width, 10 do
            for j = 0, height, 10 do
                love.graphics.circle('fill', x + i, y + j, 1)
            end
        end
    else
        -- Draw card front
        local color = self:getColor() == "red" and {0.8, 0.2, 0.2, 1} or {0.2, 0.2, 0.2, 1}
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', x, y, width, height, 5, 5)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle('line', x, y, width, height, 5, 5)
        
        -- Draw rank and suit
        love.graphics.setColor(color)
        local font = love.graphics.getFont()
        local fontSize = math.min(width / 4, height / 6)
        local displayFont = love.graphics.newFont(fontSize)
        love.graphics.setFont(displayFont)
        
        -- Top left
        love.graphics.print(self:getDisplayValue(), x + 5, y + 5)
        love.graphics.print(self:getSuitSymbol(), x + 5, y + 5 + fontSize)
        
        -- Bottom right (rotated)
        love.graphics.push()
        love.graphics.translate(x + width - 5, y + height - 5)
        love.graphics.rotate(math.pi)
        love.graphics.print(self:getDisplayValue(), 0, 0)
        love.graphics.print(self:getSuitSymbol(), 0, fontSize)
        love.graphics.pop()
        
        -- Center suit (larger)
        local centerFont = love.graphics.newFont(fontSize * 2)
        love.graphics.setFont(centerFont)
        local suitWidth = centerFont:getWidth(self:getSuitSymbol())
        local suitHeight = centerFont:getHeight()
        love.graphics.print(self:getSuitSymbol(), 
                           x + (width - suitWidth) / 2, 
                           y + (height - suitHeight) / 2)
        
        -- Restore original font
        love.graphics.setFont(font)
    end
end

return Card 