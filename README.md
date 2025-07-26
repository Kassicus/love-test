# Love2D Test Project

A simple Love2D game project to test and learn Lua and the Love2D framework.

## What is Love2D?

Love2D is a free and open-source 2D game engine written in C++. It uses Lua as its scripting language and provides a simple yet powerful API for creating 2D games.

## Prerequisites

- macOS (you're already on this!)
- Homebrew (for easy installation)

## Installation

### 1. Install Love2D

```bash
brew install love
```

### 2. Verify Installation

```bash
which love
# Should output: /opt/homebrew/bin/love
```

## Project Structure

```
love-test/
├── main.lua          # Entry point (required)
├── conf.lua          # Love2D configuration
├── src/
│   ├── player.lua    # Player module
│   └── ui.lua        # UI module
└── README.md         # This file
```

## Running the Game

### Method 1: Direct from project directory
```bash
love .
```

### Method 2: Create a .love file
```bash
zip -9 -r game.love . -x "*.git*" "*.DS_Store*"
love game.love
```

### Method 3: Run examples
```bash
# Use the runner script
./run_examples.sh

# Or run specific examples
love examples/particles
love examples/physics
love examples/snake
love examples/pong
love examples/minesweeper
```

## Controls

- **WASD** or **Arrow Keys**: Move the player
- **ESC**: Quit the game

## Features

- Modular code structure
- Player movement with boundary checking
- Real-time FPS counter
- Clean separation of concerns
- Complete Snake game implementation
- Complete Pong game implementation
- Complete Minesweeper game implementation
- Particle system example
- Physics simulation example

## Love2D Key Concepts

### Required Files
- `main.lua`: The entry point that Love2D looks for

### Core Callbacks
- `love.load()`: Called once when the game starts
- `love.update(dt)`: Called every frame for game logic
- `love.draw()`: Called every frame for rendering
- `love.keypressed(key)`: Called when a key is pressed

### Useful Modules
- `love.graphics`: Drawing and rendering
- `love.keyboard`: Keyboard input
- `love.mouse`: Mouse input
- `love.timer`: Time and FPS management
- `love.window`: Window management

## Development Tips

1. **Enable Console Output**: The `conf.lua` file has `t.console = true` for debugging
2. **Hot Reloading**: Love2D automatically reloads when you save files
3. **Modular Design**: Keep your code organized in separate modules
4. **Use Delta Time**: Always multiply movement by `dt` for smooth, frame-rate independent movement

## Next Steps

- Add sprites and images
- Implement collision detection
- Add sound effects and music
- Create multiple game states (menu, game, pause)
- Add particle effects
- Implement save/load functionality

## Resources

- [Love2D Official Documentation](https://love2d.org/wiki/)
- [Love2D Wiki](https://love2d.org/wiki/Main_Page)
- [Lua Programming Language](https://www.lua.org/manual/5.4/)
- [Love2D Community](https://love2d.org/forums/)

## Troubleshooting

### Common Issues

1. **"love: command not found"**
   - Make sure Love2D is installed: `brew install love`
   - Check your PATH: `which love`

2. **Game won't start**
   - Ensure `main.lua` exists in the project root
   - Check for syntax errors in your Lua files

3. **Performance issues**
   - Use delta time (`dt`) for movement
   - Avoid creating objects in the draw loop
   - Use object pooling for frequently created/destroyed objects
