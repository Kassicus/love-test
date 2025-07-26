# Angry Birds Clone

A complete Angry Birds game clone built with Love2D and Lua, featuring physics-based gameplay, trajectory prediction, and destructible castle structures.

## Features

### 🎯 Core Gameplay
- **5 Different Colored Birds**: Red, Green, Blue, Yellow, and Purple birds with unique physics properties
- **Physics-Based Castle**: Destructible wooden and stone blocks with realistic physics
- **Green Pigs**: Target enemies that must be destroyed to win
- **Click and Drag Launching**: Intuitive mouse controls for aiming and launching birds

### 🎮 Game Mechanics
- **Trajectory Prediction**: Real-time trajectory line shows where your bird will fly
- **Power-Based Launching**: Drag distance determines launch power and direction
- **Collision Detection**: Birds damage blocks and pigs on impact
- **Health System**: Stone blocks take 3 hits, wood blocks take 1 hit, pigs take 2 hits
- **Win/Lose Conditions**: Destroy all pigs to win, run out of birds to lose

### 🏗️ Castle Structure
- **Multi-Layer Design**: Ground, base, middle, top, and roof layers
- **Mixed Materials**: Stone blocks (stronger) and wooden blocks (weaker)
- **Strategic Placement**: Pigs positioned throughout the castle for challenging gameplay

## Controls

- **Mouse**: Click and drag birds to aim and launch
- **R**: Restart the game
- **ESC**: Quit the game

## How to Play

1. **Aim**: Click and drag a bird in the slingshot to aim
2. **Launch**: Release the mouse button to launch the bird
3. **Destroy**: Hit blocks and pigs to destroy the castle
4. **Win**: Destroy all green pigs to complete the level
5. **Strategy**: Use trajectory prediction to plan your shots

## Technical Implementation

### Physics System
- Uses Love2D's Box2D physics engine
- Realistic gravity and collision detection
- Bouncy bird physics with proper restitution
- Dynamic block destruction

### Game Architecture
- **Modular Design**: Separate classes for Bird, Castle, Slingshot, and GameState
- **Collision Callbacks**: Handles bird-block and bird-pig collisions
- **State Management**: Tracks game progress and win/lose conditions
- **Trajectory Calculation**: Physics-based trajectory prediction

### Visual Features
- **Colorful Birds**: Each bird has a distinct color and appearance
- **Detailed Pigs**: Green pigs with eyes and noses
- **Material-Based Blocks**: Different colors for stone vs wood
- **Smooth Animations**: Physics-driven movement and rotation

## Game Balance

- **5 Birds**: Limited ammunition encourages strategic thinking
- **Mixed Block Types**: Stone blocks provide challenge, wood blocks are easier to destroy
- **Pig Placement**: Pigs are strategically placed to require multiple shots
- **Physics Realism**: Realistic physics make the game feel authentic

## Development Notes

This implementation demonstrates advanced Love2D concepts including:
- Complex physics interactions
- Real-time trajectory calculation
- Modular game architecture
- Collision detection and damage systems
- Interactive mouse controls with drag mechanics

The game provides a complete Angry Birds experience with all the core mechanics players expect from the original game. 