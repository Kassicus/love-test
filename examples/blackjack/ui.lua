-- examples/blackjack/ui.lua - UI module for blackjack interface

local UI = {}
UI.__index = UI

-- UI state
local uiState = {
    font = nil,
    largeFont = nil,
    colors = {
        text = {1, 1, 1, 1},
        background = {0, 0, 0, 0.7},
        button = {0.3, 0.3, 0.3, 1},
        buttonHover = {0.5, 0.5, 0.5, 1},
        buttonActive = {0.7, 0.7, 0.7, 1},
        betButton = {0.2, 0.6, 0.2, 1},
        betButtonHover = {0.3, 0.7, 0.3, 1},
        actionButton = {0.6, 0.2, 0.2, 1},
        actionButtonHover = {0.7, 0.3, 0.3, 1}
    },
    buttons = {},
    betAmount = 10,
    minBet = 5,
    maxBet = 500,
    betIncrement = 5
}

-- Initialize UI
function UI.init()
    uiState.font = love.graphics.newFont(18)
    uiState.largeFont = love.graphics.newFont(28)
    love.graphics.setFont(uiState.font)
end

-- Update UI animations
function UI.update(dt)
    -- Update button hover states
    local mouseX, mouseY = love.mouse.getPosition()
    for _, button in ipairs(uiState.buttons) do
        button.isHovered = UI.isPointInRect(mouseX, mouseY, button.x, button.y, button.width, button.height)
    end
end

-- Handle mouse clicks
function UI.handleClick(x, y)
    for _, button in ipairs(uiState.buttons) do
        if UI.isPointInRect(x, y, button.x, button.y, button.width, button.height) then
            if button.action then
                button.action()
            end
            break
        end
    end
end

-- Check if point is in rectangle
function UI.isPointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

-- Draw betting interface
function UI.drawBettingInterface(player)
    local x = 100
    local y = 920
    local buttonWidth = 100
    local buttonHeight = 40
    local spacing = 15
    
    -- Clear previous buttons
    uiState.buttons = {}
    
    -- Bet amount display
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Bet Amount: $" .. uiState.betAmount, x, y - 30)
    if player:getBet() > 0 then
        love.graphics.print("Current Bet: $" .. player:getBet(), x, y - 10)
    end
    
    -- Decrease bet button
    local decreaseBtn = {
        x = x, y = y, width = buttonWidth, height = buttonHeight,
        text = "-$" .. uiState.betIncrement,
        color = uiState.colors.button,
        hoverColor = uiState.colors.buttonHover,
        action = function()
            uiState.betAmount = math.max(uiState.minBet, uiState.betAmount - uiState.betIncrement)
        end
    }
    table.insert(uiState.buttons, decreaseBtn)
    
    -- Increase bet button
    local increaseBtn = {
        x = x + buttonWidth + spacing, y = y, width = buttonWidth, height = buttonHeight,
        text = "+$" .. uiState.betIncrement,
        color = uiState.colors.button,
        hoverColor = uiState.colors.buttonHover,
        action = function()
            uiState.betAmount = math.min(uiState.maxBet, uiState.betAmount + uiState.betIncrement)
        end
    }
    table.insert(uiState.buttons, increaseBtn)
    
    -- Place bet button
    local placeBetBtn = {
        x = x + (buttonWidth + spacing) * 2, y = y, width = buttonWidth * 1.5, height = buttonHeight,
        text = "Place Bet",
        color = uiState.colors.betButton,
        hoverColor = uiState.colors.betButtonHover,
        action = function()
            if player:placeBet(uiState.betAmount) then
                print("Bet placed: $" .. uiState.betAmount)
            end
        end
    }
    table.insert(uiState.buttons, placeBetBtn)
    
    -- Draw all buttons
    for _, button in ipairs(uiState.buttons) do
        local color = button.isHovered and button.hoverColor or button.color
        love.graphics.setColor(color)
        love.graphics.rectangle('fill', button.x, button.y, button.width, button.height, 5, 5)
        
        love.graphics.setColor(uiState.colors.text)
        local textWidth = uiState.font:getWidth(button.text)
        local textHeight = uiState.font:getHeight()
        love.graphics.print(button.text, 
                           button.x + (button.width - textWidth) / 2,
                           button.y + (button.height - textHeight) / 2)
    end
end

-- Draw action buttons
function UI.drawActionButtons(gameState, player)
    if not gameState:isPlayerTurn() then return end
    
    local x = 600
    local y = 920
    local buttonWidth = 120
    local buttonHeight = 45
    local spacing = 15
    
    -- Clear action buttons
    for i = #uiState.buttons, 1, -1 do
        if uiState.buttons[i].isAction then
            table.remove(uiState.buttons, i)
        end
    end
    
    -- Hit button
    local hitBtn = {
        x = x, y = y, width = buttonWidth, height = buttonHeight,
        text = "Hit (H)",
        color = uiState.colors.actionButton,
        hoverColor = uiState.colors.actionButtonHover,
        isAction = true,
        action = function()
            -- This will be handled by main.lua
        end
    }
    table.insert(uiState.buttons, hitBtn)
    
    -- Stand button
    local standBtn = {
        x = x + buttonWidth + spacing, y = y, width = buttonWidth, height = buttonHeight,
        text = "Stand (S)",
        color = uiState.colors.actionButton,
        hoverColor = uiState.colors.actionButtonHover,
        isAction = true,
        action = function()
            -- This will be handled by main.lua
        end
    }
    table.insert(uiState.buttons, standBtn)
    
    -- Double button (only if can double)
    if player:canDouble() then
        local doubleBtn = {
            x = x + (buttonWidth + spacing) * 2, y = y, width = buttonWidth, height = buttonHeight,
            text = "Double (D)",
            color = uiState.colors.actionButton,
            hoverColor = uiState.colors.actionButtonHover,
            isAction = true,
            action = function()
                -- This will be handled by main.lua
            end
        }
        table.insert(uiState.buttons, doubleBtn)
    end
    
    -- Split button (only if can split)
    if player:canSplit() then
        local splitBtn = {
            x = x + (buttonWidth + spacing) * 3, y = y, width = buttonWidth, height = buttonHeight,
            text = "Split (P)",
            color = uiState.colors.actionButton,
            hoverColor = uiState.colors.actionButtonHover,
            isAction = true,
            action = function()
                -- This will be handled by main.lua
            end
        }
        table.insert(uiState.buttons, splitBtn)
    end
    
    -- Surrender button (only if can surrender)
    if player:canSurrender() then
        local surrenderBtn = {
            x = x + (buttonWidth + spacing) * 4, y = y, width = buttonWidth, height = buttonHeight,
            text = "Surrender (R)",
            color = uiState.colors.actionButton,
            hoverColor = uiState.colors.actionButtonHover,
            isAction = true,
            action = function()
                -- This will be handled by main.lua
            end
        }
        table.insert(uiState.buttons, surrenderBtn)
    end
    
    -- Draw action buttons
    for _, button in ipairs(uiState.buttons) do
        if button.isAction then
            local color = button.isHovered and button.hoverColor or button.color
            love.graphics.setColor(color)
            love.graphics.rectangle('fill', button.x, button.y, button.width, button.height, 5, 5)
            
            love.graphics.setColor(uiState.colors.text)
            local textWidth = uiState.font:getWidth(button.text)
            local textHeight = uiState.font:getHeight()
            love.graphics.print(button.text, 
                               button.x + (button.width - textWidth) / 2,
                               button.y + (button.height - textHeight) / 2)
        end
    end
end

-- Draw insurance interface
function UI.drawInsuranceInterface(gameState, player)
    if not gameState:isInsuranceOffered() then return end
    
    local x = 600
    local y = 850
    local buttonWidth = 140
    local buttonHeight = 50
    
    love.graphics.setColor(uiState.colors.background)
    love.graphics.rectangle('fill', x - 20, y - 20, buttonWidth * 2 + 40, buttonHeight + 40, 10, 10)
    
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Insurance offered! Dealer shows Ace.", x, y - 10)
    love.graphics.print("Cost: $" .. (player:getBet() / 2), x, y + 5)
    
    -- Insurance buttons
    local yesBtn = {
        x = x, y = y + 20, width = buttonWidth, height = buttonHeight,
        text = "Take Insurance (I)",
        color = uiState.colors.betButton,
        hoverColor = uiState.colors.betButtonHover,
        action = function()
            -- This will be handled by main.lua
        end
    }
    table.insert(uiState.buttons, yesBtn)
    
    local noBtn = {
        x = x + buttonWidth + 10, y = y + 20, width = buttonWidth, height = buttonHeight,
        text = "Decline",
        color = uiState.colors.button,
        hoverColor = uiState.colors.buttonHover,
        action = function()
            -- This will be handled by main.lua
        end
    }
    table.insert(uiState.buttons, noBtn)
    
    -- Draw insurance buttons
    for _, button in ipairs(uiState.buttons) do
        if button.text:find("Insurance") or button.text == "Decline" then
            local color = button.isHovered and button.hoverColor or button.color
            love.graphics.setColor(color)
            love.graphics.rectangle('fill', button.x, button.y, button.width, button.height, 5, 5)
            
            love.graphics.setColor(uiState.colors.text)
            local textWidth = uiState.font:getWidth(button.text)
            local textHeight = uiState.font:getHeight()
            love.graphics.print(button.text, 
                               button.x + (button.width - textWidth) / 2,
                               button.y + (button.height - textHeight) / 2)
        end
    end
end

-- Draw game information
function UI.drawGameInfo(gameState, player, dealer, deck)
    local x = 80
    local y = 80
    
    -- Game state message
    love.graphics.setColor(uiState.colors.text)
    love.graphics.setFont(uiState.largeFont)
    love.graphics.print(gameState:getMessage(), x, y)
    love.graphics.setFont(uiState.font)
    
    -- Player statistics
    local statsY = y + 100
    love.graphics.print("Player Stats:", x, statsY)
    love.graphics.print("Bankroll: $" .. player:getBankroll(), x, statsY + 35)
    love.graphics.print("Total Winnings: $" .. player:getTotalWinnings(), x, statsY + 70)
    love.graphics.print("Win Rate: " .. string.format("%.1f%%", player:getWinRate()), x, statsY + 105)
    
    -- Game statistics
    local gameStats = gameState:getStats()
    love.graphics.print("Game Stats:", x, statsY + 150)
    love.graphics.print(gameState:getStatsString(), x, statsY + 185)
    
    -- Deck information
    local deckX = love.graphics.getWidth() - 350
    love.graphics.print("Deck Info:", deckX, y)
    love.graphics.print("Cards Remaining: " .. deck:getRemainingCards(), deckX, y + 35)
    love.graphics.print("Penetration: " .. string.format("%.1f%%", deck:getPenetration()), deckX, y + 70)
    love.graphics.print("Running Count: " .. deck:getCardCount(), deckX, y + 105)
    love.graphics.print("True Count: " .. string.format("%.1f", deck:getTrueCount()), deckX, y + 140)
    
    -- Controls
    local controlsY = love.graphics.getHeight() - 180
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print("Controls:", x, controlsY)
    love.graphics.print("SPACE - Deal/Continue | H - Hit | S - Stand | D - Double | P - Split | R - Surrender | I - Insurance", x, controlsY + 35)
    love.graphics.print("ESC - Quit", x, controlsY + 70)
end

-- Draw the complete UI
function UI.draw(gameState, player, dealer, deck)
    -- Draw game information
    UI.drawGameInfo(gameState, player, dealer, deck)
    
    -- Draw betting interface (when waiting for bet)
    if gameState:isWaitingForBet() then
        UI.drawBettingInterface(player)
    end
    
    -- Draw action buttons (during player turn)
    if gameState:isPlayerTurn() then
        UI.drawActionButtons(gameState, player)
    end
    
    -- Draw insurance interface (when offered)
    if gameState:isInsuranceOffered() then
        UI.drawInsuranceInterface(gameState, player)
    end
end

-- Get current bet amount
function UI.getBetAmount()
    return uiState.betAmount
end

-- Set bet amount
function UI.setBetAmount(amount)
    uiState.betAmount = math.max(uiState.minBet, math.min(uiState.maxBet, amount))
end

return UI 