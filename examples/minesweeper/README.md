# Minesweeper Game

A classic Minesweeper game implementation using Love2D and Lua, featuring grid-based logic and recursive algorithms.

## How to Play

- **Left Click**: Reveal a cell
- **Right Click**: Flag/unflag a cell (mark potential mines)
- **R Key**: Restart the game
- **ESC**: Quit the game

## Game Rules

1. **Objective**: Reveal all cells that don't contain mines
2. **Numbers**: Numbers show how many mines are adjacent to that cell
3. **Flags**: Right-click to flag cells you think contain mines
4. **Recursive Revealing**: Clicking an empty cell reveals neighboring cells automatically
5. **Win Condition**: Reveal all non-mine cells to win
6. **Lose Condition**: Click on a mine to lose

## Game Features

- **16x16 Grid**: Classic intermediate difficulty
- **40 Mines**: Standard mine count for this grid size
- **Safe First Click**: First click is guaranteed to be safe
- **Recursive Revealing**: Empty cells automatically reveal neighbors
- **Mine Counter**: Shows remaining unflagged mines
- **Timer**: Tracks your completion time
- **Visual Feedback**: Color-coded numbers and clear cell states
- **Win/Lose States**: Clear game over conditions

## Game Mechanics

### Cell Types
- **Hidden Cell**: Gray, unrevealed
- **Revealed Cell**: Light gray, shows number or empty
- **Flagged Cell**: Red flag emoji
- **Mine Cell**: Red background with bomb emoji

### Number Colors
- **1**: Blue
- **2**: Green
- **3**: Red
- **4**: Dark Blue
- **5**: Dark Red
- **6**: Teal
- **7**: Black
- **8**: Gray

### Recursive Algorithm
When you click an empty cell (no adjacent mines), the game automatically reveals all neighboring cells. This creates the classic "flood fill" effect that reveals large areas of the board.

## Code Structure

The game is organized into modular components:

- `main.lua` - Main game loop, input handling, and UI
- `board.lua` - Board class (grid logic, mine placement, revealing)
- `gameState.lua` - Game state management and timer

## Technical Details

- **Grid Size**: 16x16 cells
- **Cell Size**: 30 pixels
- **Mine Count**: 40 mines
- **Window Size**: 520x580 pixels
- **First Click Safety**: Mines are placed after first click

## Learning Points

This implementation demonstrates:

1. **Grid-Based Logic** - 2D array manipulation
2. **Recursive Algorithms** - Flood fill for empty cells
3. **Random Generation** - Mine placement algorithm
4. **State Management** - Multiple game states
5. **Mouse Input** - Left/right click handling
6. **Collision Detection** - Grid coordinate conversion
7. **Data Structures** - Efficient cell tracking with hash tables

## Advanced Features

### Mine Placement Algorithm
- Mines are placed randomly after the first click
- Ensures the first click is always safe
- Prevents infinite loops with attempt limits

### Recursive Revealing
- Uses depth-first search to reveal connected empty cells
- Stops at numbered cells (cells with adjacent mines)
- Handles edge cases and boundary conditions

### Efficient Data Structures
- Uses hash tables for revealed and flagged cells
- O(1) lookup time for cell states
- Memory efficient for large grids

### Visual Design
- Color-coded numbers for easy recognition
- Clear visual distinction between cell states
- Emoji icons for mines and flags
- Professional grid layout

## Strategy Tips

1. **Start with corners**: Often reveals more cells
2. **Look for patterns**: Common number patterns indicate mine positions
3. **Use flags strategically**: Mark obvious mines to avoid clicking them
4. **Work systematically**: Reveal cells in logical patterns
5. **Don't guess**: Only click cells you're certain are safe

## Running the Game

```bash
# From the project root
love examples/minesweeper

# Or use the runner script
./run_examples.sh
```

## Game Flow

1. **Start**: Click anywhere to begin (first click is safe)
2. **Explore**: Click cells to reveal them
3. **Flag**: Right-click to mark potential mines
4. **Analyze**: Use numbers to deduce mine positions
5. **Win**: Reveal all non-mine cells
6. **Lose**: Click on a mine (game over)

## Technical Challenges Solved

- **Recursive revealing algorithm** for empty cells
- **Efficient mine placement** with first-click safety
- **Grid coordinate conversion** from screen to grid
- **State management** for revealed/flagged cells
- **Win condition detection** based on revealed cells
- **Visual feedback** with color-coded numbers

Enjoy playing! 💣🚩 