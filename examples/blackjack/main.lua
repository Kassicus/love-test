-- examples/blackjack/main.lua - Casino Blackjack Game

-- Import modules
local Deck = require('deck')
local Player = require('player')
local Dealer = require('dealer')
local GameState = require('gameState')
local UI = require('ui')

-- Game variables
local deck = nil
local player = nil
local dealer = nil
local gameState = nil

-- Game constants
local WINDOW_WIDTH = 1600
local WINDOW_HEIGHT = 1000
local TABLE_COLOR = {0.1, 0.4, 0.1, 1} -- Dark green felt
local CARD_WIDTH = 80
local CARD_HEIGHT = 120

function love.load()
    -- Set window properties
    love.window.setTitle("Casino Blackjack")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    
    -- Initialize game objects
    gameState = GameState.new()
    deck = Deck.new(6) -- 6-deck shoe
    player = Player.new()
    dealer = Dealer.new()
    
    -- Initialize UI
    UI.init()
    
    -- Set default font
    love.graphics.setFont(love.graphics.newFont(18))
    
    print("Blackjack game initialized with 6-deck shoe")
end

function love.update(dt)
    -- Update game state
    gameState:update(dt)
    
    -- Update UI animations
    UI.update(dt)
end

function love.draw()
    -- Clear screen with table color
    love.graphics.setColor(TABLE_COLOR)
    love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    
    -- Draw game elements
    drawTable()
    drawCards()
    drawUI()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        handleSpaceKey()
    elseif key == 'h' then
        handleHit()
    elseif key == 's' then
        handleStand()
    elseif key == 'd' then
        handleDouble()
    elseif key == 'p' then
        handleSplit()
    elseif key == 'i' then
        handleInsurance()
    elseif key == 'r' then
        handleSurrender()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        UI.handleClick(x, y)
    end
end

function drawTable()
    local gameAreaStart = 460 -- Left panel width + margin
    local gameAreaWidth = WINDOW_WIDTH - gameAreaStart - 50
    
    -- Draw table border
    love.graphics.setColor(0.8, 0.6, 0.4, 1) -- Brown border  
    love.graphics.rectangle('line', gameAreaStart, 50, gameAreaWidth, WINDOW_HEIGHT - 100, 10, 10)
    
    -- Draw dealer area
    love.graphics.setColor(0.2, 0.2, 0.2, 0.3)
    love.graphics.rectangle('fill', gameAreaStart + 50, 140, gameAreaWidth - 100, 200, 5, 5)
    
    -- Draw player area
    love.graphics.setColor(0.2, 0.2, 0.2, 0.3)
    love.graphics.rectangle('fill', gameAreaStart + 50, 700, gameAreaWidth - 100, 200, 5, 5)
end

function drawCards()
    local gameAreaStart = 460 -- Left panel width + margin
    
    -- Draw dealer cards
    dealer:draw(gameAreaStart + 100, 180)
    
    -- Draw player cards
    player:draw(gameAreaStart + 100, 740)
    
    -- Draw deck visualization
    deck:draw(gameAreaStart + 50, 450)
end

function drawUI()
    UI.draw(gameState, player, dealer, deck)
end

function handleSpaceKey()
    if gameState:isWaitingForBet() then
        if player:getBet() > 0 then
            -- Clear previous hand before starting new one
            player:clearHands()
            dealer:clearHand()
            gameState:startNewHand()
            dealInitialCards()
        else
            print("Please place a bet first")
        end
    elseif gameState:isGameOver() then
        gameState:resetForNewHand()
        player:reset()
        dealer:reset()
    end
end

function handleHit()
    if gameState:isPlayerTurn() then
        local card = deck:drawCard()
        if card then
            player:addCard(card)
            print("Player hit: " .. card:toString())
            
            if player:getHandValue() > 21 then
                -- Hand is bust, check if there are more hands
                if player:nextHand() then
                    print("Hand busted, moving to next hand")
                else
                    gameState:playerBust()
                    dealerPlay()
                end
            elseif player:getHandValue() == 21 then
                -- Hand is 21, check if there are more hands
                if player:nextHand() then
                    print("Hand is 21, moving to next hand")
                else
                    gameState:playerStand()
                    dealerPlay()
                end
            end
        end
    end
end

function handleStand()
    if gameState:isPlayerTurn() then
        -- Check if there are more hands to play
        if player:nextHand() then
            -- Move to next hand
            print("Moving to next hand")
        else
            -- All hands are done, dealer plays
            gameState:playerStand()
            dealerPlay()
        end
    end
end

function handleDouble()
    if gameState:isPlayerTurn() and player:canDouble() then
        player:doubleBet()
        local card = deck:drawCard()
        if card then
            player:addCard(card)
            print("Player doubles: " .. card:toString())
            
            if player:getHandValue() > 21 then
                -- Hand is bust on double, check if there are more hands
                if player:nextHand() then
                    print("Hand busted on double, moving to next hand")
                else
                    gameState:playerBust()
                    dealerPlay()
                end
            else
                -- Hand is complete on double, check if there are more hands
                if player:nextHand() then
                    print("Double complete, moving to next hand")
                else
                    gameState:playerStand()
                    dealerPlay()
                end
            end
        end
    end
end

function handleSplit()
    if gameState:isPlayerTurn() and player:canSplit() then
        if player:splitHand() then
            print("Player splits hand")
            
            -- Deal a card to the first split hand
            local card1 = deck:drawCard()
            if card1 then
                player:addCard(card1)
                print("Dealt to first split hand: " .. card1:toString())
            end
            
            -- Deal a card to the second split hand
            player:nextHand()
            local card2 = deck:drawCard()
            if card2 then
                player:addCard(card2)
                print("Dealt to second split hand: " .. card2:toString())
            end
            
            -- Go back to first hand
            player.currentHand = 1
        end
    end
end

function handleInsurance()
    if gameState:isInsuranceOffered() then
        player:takeInsurance()
        gameState:insuranceTaken()
        print("Player takes insurance")
    end
end

function handleSurrender()
    if gameState:isPlayerTurn() and player:canSurrender() then
        player:surrender()
        gameState:playerSurrendered()
        print("Player surrenders")
    end
end

function dealInitialCards()
    -- Deal first card to player
    local card1 = deck:drawCard()
    if card1 then
        player:addCard(card1)
        print("Player dealt: " .. card1:toString())
    end
    
    -- Deal first card to dealer (face up)
    local card2 = deck:drawCard()
    if card2 then
        dealer:addCard(card2)
        print("Dealer dealt: " .. card2:toString())
    end
    
    -- Deal second card to player
    local card3 = deck:drawCard()
    if card3 then
        player:addCard(card3)
        print("Player dealt: " .. card3:toString())
    end
    
    -- Deal second card to dealer (face down)
    local card4 = deck:drawCard()
    if card4 then
        dealer:addCardFaceDown(card4)
        print("Dealer dealt face down: " .. card4:toString())
    end
    
    -- Check for blackjack
    if player:hasBlackjack() then
        if dealer:hasBlackjack() then
            gameState:push()
            player:pushHand()
            print("Both player and dealer have blackjack - Push!")
        else
            gameState:playerBlackjack()
            player:winHand(nil, 1.5) -- 3:2 payout
            print("Player blackjack!")
        end
    elseif dealer:hasBlackjack() then
        gameState:dealerBlackjack()
        player:loseHand()
        print("Dealer blackjack!")
    else
        gameState:startPlayerTurn()
        
        -- Offer insurance if dealer shows Ace
        if dealer:showsAce() then
            gameState:offerInsurance()
        end
    end
end

function dealerPlay()
    dealer:revealHoleCard()
    
    while dealer:shouldHit() do
        local card = deck:drawCard()
        if card then
            dealer:addCard(card)
            print("Dealer hits: " .. card:toString())
        end
    end
    
    local dealerValue = dealer:getHandValue()
    print("Dealer final value: " .. dealerValue)
    
    -- Evaluate all player hands against dealer
    local hands = player:getHands()
    local totalWins = 0
    local totalLosses = 0
    local totalPushes = 0
    
    for handIndex, hand in ipairs(hands) do
        if #hand > 0 then -- Only evaluate hands that have cards
            local playerValue = player:getHandValue(handIndex)
            print("Hand " .. handIndex .. " value: " .. playerValue)
            
            if playerValue > 21 then
                -- Hand was already bust
                totalLosses = totalLosses + 1
                print("Hand " .. handIndex .. " was bust")
            elseif dealerValue > 21 then
                -- Dealer bust, player wins
                player:winHand(handIndex)
                totalWins = totalWins + 1
                print("Hand " .. handIndex .. " wins (dealer bust)")
            elseif dealerValue > playerValue then
                -- Dealer wins
                player:loseHand(handIndex)
                totalLosses = totalLosses + 1
                print("Hand " .. handIndex .. " loses to dealer")
            elseif dealerValue < playerValue then
                -- Player wins
                player:winHand(handIndex)
                totalWins = totalWins + 1
                print("Hand " .. handIndex .. " beats dealer")
            else
                -- Push
                player:pushHand(handIndex)
                totalPushes = totalPushes + 1
                print("Hand " .. handIndex .. " pushes with dealer")
            end
        end
    end
    
    -- Determine overall game result
    if totalWins > totalLosses then
        gameState:playerWon()
        print("Player wins overall: " .. totalWins .. " wins, " .. totalLosses .. " losses")
    elseif totalLosses > totalWins then
        gameState:dealerWon()
        print("Dealer wins overall: " .. totalLosses .. " losses, " .. totalWins .. " wins")
    else
        gameState:push()
        print("Overall push: " .. totalWins .. " wins, " .. totalLosses .. " losses, " .. totalPushes .. " pushes")
    end
end

return {
    handleSpaceKey = handleSpaceKey,
    handleHit = handleHit,
    handleStand = handleStand,
    handleDouble = handleDouble,
    handleSplit = handleSplit,
    handleInsurance = handleInsurance,
    handleSurrender = handleSurrender
} 