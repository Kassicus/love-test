# Pong Game

A classic Pong game implementation using Love2D and Lua, featuring player vs AI gameplay.

## How to Play

- **W/S** or **Up/Down Arrow Keys**: Move your paddle (left side)
- **SPACE**: Serve the ball or restart the game
- **ESC**: Quit the game

## Game Rules

1. **Objective**: Be the first to score 11 points
2. **Scoring**: Score a point when the opponent misses the ball
3. **Serving**: Press SPACE to serve the ball in a random direction
4. **Movement**: Use W/S to move your paddle up and down
5. **AI Opponent**: The right paddle is controlled by AI

## Features

- **Realistic Physics**: Ball bounces off paddles with angle-based deflection
- **AI Opponent**: Simple but effective AI that tracks the ball
- **Visual Polish**: Different colors for player (green) and AI (red) paddles
- **Center Line**: Classic dashed center line for visual separation
- **Score Display**: Real-time score tracking
- **Game States**: Waiting, playing, and game over states
- **Smooth Controls**: Responsive paddle movement

## Game Mechanics

### Ball Physics
- Ball bounces off paddles with realistic angles
- Bounce angle depends on where the ball hits the paddle
- Ball speed is maintained to prevent slow rallies
- Top and bottom wall bouncing

### AI Behavior
- AI tracks the ball's Y position
- Moves paddle to intercept the ball
- Simple but challenging opponent

### Scoring System
- First player to reach 11 points wins
- Ball resets to center after each point
- Game pauses between points for serving

## Code Structure

The game is organized into modular components:

- `main.lua` - Main game loop and coordination
- `paddle.lua` - Paddle class (player and AI movement)
- `ball.lua` - Ball physics and collision detection
- `gameState.lua` - Game state management and scoring

## Technical Details

- **Window Size**: 800x600 pixels
- **Paddle Size**: 15x80 pixels
- **Ball Size**: 10 pixels diameter
- **Paddle Speed**: 300 pixels/second
- **Ball Speed**: 250 pixels/second
- **Winning Score**: 11 points

## Learning Points

This implementation demonstrates:

1. **Physics Simulation** - Realistic ball bouncing
2. **AI Programming** - Simple opponent AI
3. **Collision Detection** - Precise paddle-ball collision
4. **Game State Management** - Multiple game states
5. **Input Handling** - Responsive controls
6. **Modular Design** - Clean separation of concerns
7. **Real-time Gameplay** - Smooth 60 FPS gameplay

## Advanced Features

### Ball Physics
- Angle-based deflection based on paddle hit position
- Speed maintenance to prevent slow rallies
- Wall collision detection and bouncing

### AI Implementation
- Ball tracking and prediction
- Smooth paddle movement
- Challenging but fair gameplay

### Visual Design
- Color-coded paddles (green player, red AI)
- Classic center line design
- Clean, minimalist interface

## Running the Game

```bash
# From the project root
love examples/pong

# Or use the runner script
./run_examples.sh
```

## Game Flow

1. **Start**: Game begins in waiting state
2. **Serve**: Press SPACE to serve the ball
3. **Rally**: Ball bounces between paddles
4. **Score**: Point awarded when ball is missed
5. **Reset**: Ball returns to center for next serve
6. **Win**: First to 11 points wins the game

Enjoy playing! 🏓 