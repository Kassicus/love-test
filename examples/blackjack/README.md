# Casino Blackjack Game

A comprehensive blackjack implementation with full casino rules, betting system, and 6-deck shoe.

## Features

### Core Gameplay
- **6-Deck Shoe**: Authentic casino-style multi-deck shoe with automatic reshuffling
- **Full Casino Rules**: All standard blackjack rules implemented
- **Betting System**: Adjustable bet amounts with bankroll management
- **Card Counting**: Running count and true count display for advanced players

### Player Actions
- **Hit**: Take another card
- **Stand**: Keep current hand
- **Double Down**: Double your bet and take exactly one more card
- **Split**: Split matching cards into separate hands
- **Surrender**: Give up half your bet (available on first two cards)
- **Insurance**: Bet against dealer blackjack when dealer shows Ace

### Game Features
- **Multiple Hands**: Support for split hands
- **Ace Adjustment**: Automatic soft/hard hand calculation
- **Blackjack Payout**: 3:2 payout for natural blackjack
- **Dealer AI**: Standard casino rules (hit on soft 17)
- **Statistics Tracking**: Win rate, hands played, blackjack frequency
- **Visual Feedback**: Card animations, hand values, game state messages

## How to Play

### Getting Started
1. **Place Your Bet**: Use the betting interface to set your bet amount
2. **Deal Cards**: Press SPACE to deal the initial cards
3. **Make Decisions**: Choose your action based on your hand and dealer's up card

### Controls
- **SPACE**: Deal cards / Continue to next hand
- **H**: Hit (take another card)
- **S**: Stand (keep current hand)
- **D**: Double down (double bet, take one card)
- **P**: Split (split matching cards)
- **R**: Surrender (give up half bet)
- **I**: Take insurance (when offered)
- **ESC**: Quit game

### Betting
- **Minimum Bet**: $5
- **Maximum Bet**: $500
- **Bet Increment**: $5
- **Starting Bankroll**: $1,000

### Game Rules

#### Basic Play
- Get as close to 21 as possible without going over
- Face cards (J, Q, K) are worth 10
- Aces are worth 1 or 11 (automatically adjusted)
- Dealer must hit on 16 and below, stand on 17 and above

#### Special Rules
- **Blackjack**: Natural 21 pays 3:2
- **Insurance**: Available when dealer shows Ace, pays 2:1
- **Double Down**: Available on first two cards
- **Split**: Available on matching first two cards
- **Surrender**: Available on first two cards, returns half bet

#### Payouts
- **Win**: 1:1 (even money)
- **Blackjack**: 3:2
- **Insurance**: 2:1 (if dealer has blackjack)
- **Push**: Bet returned (tie)

## Advanced Features

### Card Counting
The game displays:
- **Running Count**: High-low card counting system
- **True Count**: Running count divided by decks remaining
- **Penetration**: Percentage of cards dealt from shoe

### Statistics
- **Win Rate**: Percentage of hands won
- **Blackjack Rate**: Frequency of natural blackjacks
- **Total Winnings**: Cumulative profit/loss
- **Hands Played**: Total number of hands completed

### Visual Elements
- **Card Graphics**: Detailed card rendering with suits and ranks
- **Table Layout**: Casino-style green felt table
- **Deck Visualization**: Shows remaining cards and penetration
- **Hand Values**: Real-time calculation and display
- **Game State**: Clear messages about current game phase

## Technical Details

### Architecture
- **Modular Design**: Separate modules for cards, deck, player, dealer, game state, and UI
- **State Management**: Comprehensive game state tracking
- **Event-Driven**: Keyboard and mouse input handling
- **Logging**: Console output for debugging and game flow

### Performance
- **Efficient Rendering**: Optimized card drawing and UI updates
- **Memory Management**: Proper cleanup and resource management
- **Smooth Animations**: 60 FPS gameplay with smooth transitions

## File Structure
```
examples/blackjack/
├── main.lua          # Main game loop and input handling
├── card.lua          # Card representation and rendering
├── deck.lua          # 6-deck shoe management
├── player.lua        # Player hands and betting
├── dealer.lua        # Dealer AI and hand management
├── gameState.lua     # Game state and flow control
├── ui.lua           # User interface and controls
└── README.md        # This file
```

## Running the Game

1. Navigate to the blackjack directory
2. Run with Love2D: `love .`
3. Or use the run script: `../run_examples.sh blackjack`

## Future Enhancements

- **Sound Effects**: Card dealing, chip sounds, win/lose audio
- **Animations**: Card dealing animations, chip movements
- **Multiplayer**: Network play with other players
- **Strategy Advisor**: Basic strategy suggestions
- **Tournament Mode**: Multiple players, elimination rounds
- **Custom Rules**: Different house rules and variations

Enjoy playing casino-style blackjack! 