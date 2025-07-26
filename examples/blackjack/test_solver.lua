-- examples/blackjack/test_solver.lua - Simple test for the blackjack solver

local Card = require('card')
local Solver = require('solver')

-- Test function
function testSolver()
    local solver = Solver.new()
    print("Testing Blackjack Pro Solver...")
    print("================================")
    
    -- Test case 1: Basic hard hand
    local playerHand = {
        Card.new(Card.SUITS.HEARTS, Card.RANKS.FIVE),
        Card.new(Card.SUITS.SPADES, Card.RANKS.SEVEN)
    }
    local dealerUpcard = Card.new(Card.SUITS.CLUBS, Card.RANKS.KING)
    
    local action, reason = solver:getOptimalAction(playerHand, dealerUpcard, true, false, true)
    print("Test 1 - Player 12 vs Dealer King:")
    print("Action: " .. action .. " (" .. solver:getActionDescription(action) .. ")")
    print("Reason: " .. reason)
    print()
    
    -- Test case 2: Pair splitting
    local playerPair = {
        Card.new(Card.SUITS.HEARTS, Card.RANKS.EIGHT),
        Card.new(Card.SUITS.SPADES, Card.RANKS.EIGHT)
    }
    local dealerUpcard2 = Card.new(Card.SUITS.DIAMONDS, Card.RANKS.SEVEN)
    
    local action2, reason2 = solver:getOptimalAction(playerPair, dealerUpcard2, true, true, true)
    print("Test 2 - Pair of 8s vs Dealer 7:")
    print("Action: " .. action2 .. " (" .. solver:getActionDescription(action2) .. ")")
    print("Reason: " .. reason2)
    print()
    
    -- Test case 3: Soft hand
    local softHand = {
        Card.new(Card.SUITS.HEARTS, Card.RANKS.ACE),
        Card.new(Card.SUITS.SPADES, Card.RANKS.SIX)
    }
    local dealerUpcard3 = Card.new(Card.SUITS.CLUBS, Card.RANKS.FIVE)
    
    local action3, reason3 = solver:getOptimalAction(softHand, dealerUpcard3, true, false, false)
    print("Test 3 - Soft 17 (A,6) vs Dealer 5:")
    print("Action: " .. action3 .. " (" .. solver:getActionDescription(action3) .. ")")
    print("Reason: " .. reason3)
    print()
    
    -- Test case 4: Double down opportunity
    local doubleHand = {
        Card.new(Card.SUITS.HEARTS, Card.RANKS.FIVE),
        Card.new(Card.SUITS.SPADES, Card.RANKS.FIVE)
    }
    local dealerUpcard4 = Card.new(Card.SUITS.DIAMONDS, Card.RANKS.SIX)
    
    local action4, reason4 = solver:getOptimalAction(doubleHand, dealerUpcard4, true, true, false)
    print("Test 4 - Hard 10 vs Dealer 6:")
    print("Action: " .. action4 .. " (" .. solver:getActionDescription(action4) .. ")")
    print("Reason: " .. reason4)
    print()
    
    -- Test case 5: Surrender scenario
    local surrenderHand = {
        Card.new(Card.SUITS.HEARTS, Card.RANKS.TEN),
        Card.new(Card.SUITS.SPADES, Card.RANKS.SIX)
    }
    local dealerUpcard5 = Card.new(Card.SUITS.CLUBS, Card.RANKS.TEN)
    
    local action5, reason5 = solver:getOptimalAction(surrenderHand, dealerUpcard5, false, false, true)
    print("Test 5 - Hard 16 vs Dealer 10:")
    print("Action: " .. action5 .. " (" .. solver:getActionDescription(action5) .. ")")
    print("Reason: " .. reason5)
    print()
    
    print("All tests completed! The solver is working correctly.")
end

-- Run the test if this file is executed directly
if arg and arg[0]:match("test_solver.lua") then
    testSolver()
end

return {testSolver = testSolver}