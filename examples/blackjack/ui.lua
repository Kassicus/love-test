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

-- Helper function to wrap text within a given width
function UI.wrapText(text, maxWidth, font)
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    
    local lines = {}
    local currentLine = ""
    
    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or currentLine .. " " .. word
        if font:getWidth(testLine) <= maxWidth then
            currentLine = testLine
        else
            if currentLine ~= "" then
                table.insert(lines, currentLine)
            end
            currentLine = word
        end
    end
    
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    return lines
end

-- Helper function to draw wrapped text
function UI.drawWrappedText(text, x, y, maxWidth, font, lineHeight)
    lineHeight = lineHeight or 20
    local lines = UI.wrapText(text, maxWidth, font)
    local currentY = y
    
    for _, line in ipairs(lines) do
        love.graphics.print(line, x, currentY)
        currentY = currentY + lineHeight
    end
    
    return currentY - y -- Return total height used
end

-- Draw betting interface in left panel with consistent spacing
function UI.drawBettingInterface(player, panelStartY)
    local x = 40  -- Same as other sections
    local y = panelStartY or 560
    local buttonWidth = 90
    local buttonHeight = 35
    local spacing = 10
    local sectionHeight = 80  -- Proper height for betting section
    
    -- Clear previous buttons
    uiState.buttons = {}
    
    -- Draw betting section background (same pattern as other sections)
    love.graphics.setColor(0.4, 0.4, 0.2, 0.7)
    love.graphics.rectangle('fill', x - 5, y - 5, 370, sectionHeight, 5, 5)  -- Consistent with other sections
    
    -- Bet amount display
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Bet Amount: $" .. uiState.betAmount, x, y)
    if player:getBet() > 0 then
        love.graphics.print("Current Bet: $" .. player:getBet(), x, y + 20)
    end
    
    -- Decrease bet button (position below the text)
    local decreaseBtn = {
        x = x, y = y + 40, width = buttonWidth, height = buttonHeight,
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
        x = x + buttonWidth + spacing, y = y + 40, width = buttonWidth, height = buttonHeight,
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
        x = x + (buttonWidth + spacing) * 2, y = y + 40, width = buttonWidth * 1.5, height = buttonHeight,
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

-- Draw action buttons in left panel
function UI.drawActionButtons(gameState, player, panelStartY)
    if not gameState:isPlayerTurn() then return end
    
    local x = 40
    local y = panelStartY or 700
    local buttonWidth = 110
    local buttonHeight = 35
    local spacing = 10
    
    -- Draw action section background
    love.graphics.setColor(0.2, 0.4, 0.4, 0.7)
    love.graphics.rectangle('fill', x - 5, y - 10, 360, 120, 5, 5)
    
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
            x = x, y = y + buttonHeight + spacing, width = buttonWidth, height = buttonHeight,
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
            x = x + buttonWidth + spacing, y = y + buttonHeight + spacing, width = buttonWidth, height = buttonHeight,
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
            x = x + (buttonWidth + spacing) * 2, y = y, width = buttonWidth, height = buttonHeight,
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

-- Draw insurance interface in left panel
function UI.drawInsuranceInterface(gameState, player, panelStartY)
    if not gameState:isInsuranceOffered() then return end
    
    local x = 40
    local y = panelStartY or 640
    local buttonWidth = 120
    local buttonHeight = 40
    
    love.graphics.setColor(0.4, 0.2, 0.4, 0.7)
    love.graphics.rectangle('fill', x - 5, y - 20, 360, buttonHeight + 40, 5, 5)
    
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

-- Draw left info panel with simple, predictable spacing
function UI.drawLeftPanel(gameState, player, dealer, deck)
    local panelWidth = 400
    local panelHeight = love.graphics.getHeight() - 100
    local panelX = 20
    local panelY = 20
    
    -- Draw main panel background
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle('fill', panelX, panelY, panelWidth, panelHeight, 10, 10)
    
    -- Panel border
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle('line', panelX, panelY, panelWidth, panelHeight, 10, 10)
    
    local leftMargin = panelX + 20
    local currentY = panelY + 10 -- 10px padding from top
    local sectionSpacing = 10 -- 10px between each section
    
    -- 1. Game State Message Section (50px height)
    love.graphics.setColor(0.2, 0.2, 0.2, 0.7)
    love.graphics.rectangle('fill', leftMargin - 5, currentY - 5, panelWidth - 30, 50, 5, 5)
    love.graphics.setColor(uiState.colors.text)
    love.graphics.setFont(uiState.largeFont)
    local message = gameState:getMessage()
    love.graphics.print(message, leftMargin, currentY + 10)
    love.graphics.setFont(uiState.font)
    currentY = currentY + 50 + sectionSpacing
    
    -- 2. Player Statistics Section (85px height)
    love.graphics.setColor(0.2, 0.4, 0.2, 0.7)
    love.graphics.rectangle('fill', leftMargin - 5, currentY - 5, panelWidth - 30, 85, 5, 5)
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Player Stats:", leftMargin, currentY)
    love.graphics.print("Bankroll: $" .. player:getBankroll(), leftMargin, currentY + 20)
    love.graphics.print("Total Winnings: $" .. player:getTotalWinnings(), leftMargin, currentY + 40)
    love.graphics.print("Win Rate: " .. string.format("%.1f%%", player:getWinRate()), leftMargin, currentY + 60)
    currentY = currentY + 85 + sectionSpacing
    
    -- 3. Game Statistics Section (95px height)
    love.graphics.setColor(0.2, 0.2, 0.4, 0.7)
    love.graphics.rectangle('fill', leftMargin - 5, currentY - 5, panelWidth - 30, 95, 5, 5)
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Game Stats:", leftMargin, currentY)
    local gameStats = gameState:getStats()
    love.graphics.print("Hands: " .. gameStats.handsPlayed, leftMargin, currentY + 20)
    love.graphics.print("Wins: " .. gameStats.playerWins .. " | Losses: " .. gameStats.dealerWins, leftMargin, currentY + 40)
    love.graphics.print("Pushes: " .. gameStats.pushes, leftMargin, currentY + 60)
    love.graphics.print("Win Rate: " .. string.format("%.1f%%", gameStats.playerWinRate), leftMargin, currentY + 75)
    currentY = currentY + 95 + sectionSpacing
    
    -- 4. Deck Information Section (105px height)
    love.graphics.setColor(0.4, 0.2, 0.2, 0.7)
    love.graphics.rectangle('fill', leftMargin - 5, currentY - 5, panelWidth - 30, 105, 5, 5)
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Deck Info:", leftMargin, currentY)
    love.graphics.print("Cards Remaining: " .. deck:getRemainingCards(), leftMargin, currentY + 20)
    love.graphics.print("Penetration: " .. string.format("%.1f%%", deck:getPenetration()), leftMargin, currentY + 40)
    love.graphics.print("Running Count: " .. deck:getCardCount(), leftMargin, currentY + 60)
    love.graphics.print("True Count: " .. string.format("%.1f", deck:getTrueCount()), leftMargin, currentY + 80)
    currentY = currentY + 105 + sectionSpacing
    
    -- 5. Controls Section (155px height)
    love.graphics.setColor(0.3, 0.3, 0.3, 0.7)
    love.graphics.rectangle('fill', leftMargin - 5, currentY - 5, panelWidth - 30, 155, 5, 5)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.print("Controls:", leftMargin, currentY)
    love.graphics.print("SPACE - Deal/Continue", leftMargin, currentY + 20)
    love.graphics.print("H - Hit", leftMargin, currentY + 38)
    love.graphics.print("S - Stand", leftMargin, currentY + 56)
    love.graphics.print("D - Double", leftMargin, currentY + 74)
    love.graphics.print("P - Split", leftMargin, currentY + 92)
    love.graphics.print("R - Surrender", leftMargin, currentY + 110)
    love.graphics.print("I - Insurance", leftMargin, currentY + 128)
    love.graphics.print("ESC - Quit", leftMargin, currentY + 146)
    
    return panelWidth + 40 -- Return the right edge of the panel
end

-- Draw the complete UI with split layout
function UI.draw(gameState, player, dealer, deck)
    -- Draw left panel with all static UI elements
    local gameAreaStart = UI.drawLeftPanel(gameState, player, dealer, deck)
    
    -- Calculate Y position for interactive elements (after all static sections)
    -- Panel starts at 20, has 10px padding, then:
    -- Game Message: 50px + 10px spacing = 70px
    -- Player Stats: 85px + 10px spacing = 165px  
    -- Game Stats: 95px + 10px spacing = 270px
    -- Deck Info: 105px + 10px spacing = 385px
    -- Controls: 155px + 10px spacing = 550px
    local interactiveStartY = 20 + 10 + 50 + 10 + 85 + 10 + 95 + 10 + 105 + 10 + 155 + 10 -- 560px from top
    
    -- Only draw interactive elements if there's space and they won't exceed panel bounds
    local panelHeight = love.graphics.getHeight() - 100
    if interactiveStartY + 100 < panelHeight then
        -- Draw betting interface (when waiting for bet)
        if gameState:isWaitingForBet() then
            UI.drawBettingInterface(player, interactiveStartY)
            interactiveStartY = interactiveStartY + 80
        end
        
        -- Draw insurance interface (when offered)
        if gameState:isInsuranceOffered() then
            UI.drawInsuranceInterface(gameState, player, interactiveStartY)
            interactiveStartY = interactiveStartY + 60
        end
        
        -- Draw action buttons (during player turn)
        if gameState:isPlayerTurn() then
            UI.drawActionButtons(gameState, player, interactiveStartY)
        end
    end
    
    return gameAreaStart
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