# Getting Started with Love2D

## Quick Start Guide

### ✅ What's Already Set Up

1. **Love2D is installed** via Homebrew
2. **Project structure** is ready with modular code
3. **Examples** are available to learn from
4. **Documentation** is comprehensive

### 🎮 How to Run Your Games

#### Main Game
```bash
love .
```

#### Examples
```bash
# Run the examples runner script
./run_examples.sh

# Or run examples directly
love examples/particles
love examples/physics
```

### 📁 Project Structure
```
love-test/
├── main.lua              # Main game entry point
├── conf.lua              # Love2D configuration
├── src/                  # Source code modules
│   ├── player.lua        # Player class
│   └── ui.lua           # UI utilities
├── examples/            # Example projects
│   ├── particles/       # Particle system demo
│   └── physics/         # Physics demo
├── run_examples.sh      # Example runner script
├── README.md           # Project overview
├── DEVELOPMENT.md      # Development guide
└── GETTING_STARTED.md  # This file
```

### 🎯 What You Can Do Now

1. **Modify the main game** in `main.lua`
2. **Add new features** by creating modules in `src/`
3. **Study the examples** to learn advanced features
4. **Play the games** - Snake, Pong, and Minesweeper are fully functional!
5. **Experiment** with different Love2D modules

### 🔧 Key Love2D Concepts

#### Required Files
- `main.lua` - Entry point (required)
- `conf.lua` - Configuration (optional but recommended)

#### Core Functions
```lua
function love.load()    -- Called once at startup
function love.update(dt) -- Called every frame for game logic
function love.draw()    -- Called every frame for rendering
function love.keypressed(key) -- Called when key is pressed
```

#### Essential Modules
- `love.graphics` - Drawing and rendering
- `love.keyboard` - Keyboard input
- `love.mouse` - Mouse input
- `love.timer` - Time management
- `love.physics` - Physics engine
- `love.audio` - Sound and music

### 🚀 Next Steps

1. **Run the main game** and experiment with the controls
2. **Try the examples** to see different Love2D features
3. **Read the documentation** in `README.md` and `DEVELOPMENT.md`
4. **Start coding** your own features!

### 💡 Tips for Success

- **Use delta time** (`dt`) for smooth movement
- **Organize code** into modules like in `src/`
- **Enable console output** for debugging (already set in `conf.lua`)
- **Test frequently** - Love2D hot-reloads when you save files

### 🆘 Need Help?

- Check the **Love2D Wiki**: https://love2d.org/wiki/
- Visit the **Love2D Forums**: https://love2d.org/forums/
- Join the **Discord**: https://discord.gg/love2d

---

**You're all set! Happy coding! 🎮** 