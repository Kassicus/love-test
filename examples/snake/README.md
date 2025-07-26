# Snake Game

A classic Snake game implementation using Love2D and Lua.

## How to Play

- **WASD** or **Arrow Keys**: Control the snake's direction
- **SPACE**: Restart the game when game over
- **ESC**: Quit the game

## Game Rules

1. **Objective**: Eat the red food to grow longer and increase your score
2. **Movement**: The snake moves continuously in the current direction
3. **Growth**: Each food eaten adds one segment to the snake's body
4. **Collision**: Game ends if you hit the walls or your own body
5. **Scoring**: +10 points for each food eaten

## Features

- **Smooth Movement**: Snake moves at a consistent speed
- **Collision Detection**: Wall and self-collision detection
- **Food Placement**: Food spawns randomly, avoiding snake body
- **Visual Feedback**: Different colors for head and body segments
- **Score System**: Real-time score display
- **Game States**: Playing and game over states
- **Restart Functionality**: Easy game restart

## Code Structure

The game is organized into modular components:

- `main.lua` - Main game loop and coordination
- `snake.lua` - Snake class (movement, growth, collision)
- `food.lua` - Food class (placement, rendering)
- `gameState.lua` - Game state management

## Technical Details

- **Grid Size**: 20x20 cells
- **Cell Size**: 25 pixels
- **Movement Speed**: Every 0.15 seconds
- **Initial Length**: 3 segments (head + 2 body)

## Learning Points

This implementation demonstrates:

1. **Object-Oriented Design** in Lua
2. **Game State Management**
3. **Collision Detection**
4. **Grid-Based Movement**
5. **Modular Code Organization**
6. **Input Handling**
7. **Timer-Based Updates**

## Running the Game

```bash
# From the project root
love examples/snake

# Or use the runner script
./run_examples.sh
```

Enjoy playing! 🐍 