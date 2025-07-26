# Love2D Development Guide

This guide covers best practices and tips for developing games with Love2D.

## Project Structure Best Practices

### Recommended Structure
```
your-game/
├── main.lua              # Entry point
├── conf.lua              # Configuration
├── src/                  # Source code
│   ├── entities/         # Game objects
│   ├── systems/          # Game systems
│   ├── ui/              # User interface
│   └── utils/           # Utility functions
├── assets/              # Game assets
│   ├── images/
│   ├── sounds/
│   └── fonts/
├── examples/            # Example code
└── docs/               # Documentation
```

## Coding Best Practices

### 1. Use Delta Time
Always multiply movement by `dt` for frame-rate independent movement:
```lua
-- Good
player.x = player.x + player.speed * dt

-- Bad
player.x = player.x + player.speed
```

### 2. Organize Code into Modules
```lua
-- player.lua
local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    return self
end

function Player:update(dt)
    -- Update logic
end

return Player
```

### 3. Use Object-Oriented Patterns
```lua
-- Constructor pattern
function MyClass.new()
    local self = {}
    setmetatable(self, {__index = MyClass})
    return self
end

-- Method definition
function MyClass:methodName()
    -- self refers to the instance
end
```

### 4. Handle Resources Properly
```lua
-- Load resources in love.load()
function love.load()
    images = {
        player = love.graphics.newImage("assets/player.png"),
        background = love.graphics.newImage("assets/background.png")
    }
    sounds = {
        jump = love.audio.newSource("assets/jump.wav", "static")
    }
end
```

## Performance Tips

### 1. Avoid Creating Objects in Draw Loop
```lua
-- Bad - creates new table every frame
function love.draw()
    local color = {1, 0, 0, 1}  -- Don't do this!
    love.graphics.setColor(color)
end

-- Good - reuse existing table
local redColor = {1, 0, 0, 1}
function love.draw()
    love.graphics.setColor(redColor)
end
```

### 2. Use Object Pooling
```lua
-- For frequently created/destroyed objects
local bulletPool = {}

function createBullet()
    if #bulletPool > 0 then
        return table.remove(bulletPool)
    else
        return Bullet.new()
    end
end

function destroyBullet(bullet)
    bullet:reset()
    table.insert(bulletPool, bullet)
end
```

### 3. Batch Drawing Operations
```lua
-- Draw similar objects together
function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    for i, sprite in ipairs(sprites) do
        love.graphics.draw(sprite.image, sprite.x, sprite.y)
    end
end
```

## Debugging Tips

### 1. Enable Console Output
```lua
-- In conf.lua
function love.conf(t)
    t.console = true
end
```

### 2. Use Print Statements
```lua
function love.update(dt)
    print("FPS:", love.timer.getFPS())
    print("Player position:", player.x, player.y)
end
```

### 3. Visual Debugging
```lua
function love.draw()
    -- Draw hitboxes
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle('line', player.x - player.width/2, 
                           player.y - player.height/2, 
                           player.width, player.height)
end
```

## Common Patterns

### 1. State Management
```lua
local gameState = "menu" -- "menu", "playing", "paused"

function love.update(dt)
    if gameState == "menu" then
        updateMenu(dt)
    elseif gameState == "playing" then
        updateGame(dt)
    elseif gameState == "paused" then
        updatePause(dt)
    end
end
```

### 2. Input Handling
```lua
local input = {
    left = false,
    right = false,
    jump = false
}

function love.keypressed(key)
    if key == "left" or key == "a" then
        input.left = true
    elseif key == "right" or key == "d" then
        input.right = true
    elseif key == "space" then
        input.jump = true
    end
end

function love.keyreleased(key)
    if key == "left" or key == "a" then
        input.left = false
    elseif key == "right" or key == "d" then
        input.right = false
    elseif key == "space" then
        input.jump = false
    end
end
```

### 3. Collision Detection
```lua
function checkCollision(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
end
```

## Asset Management

### 1. Loading Images
```lua
local images = {}

function loadImages()
    images.player = love.graphics.newImage("assets/player.png")
    images.background = love.graphics.newImage("assets/background.png")
    -- Set filter for pixel art
    images.player:setFilter("nearest", "nearest")
end
```

### 2. Loading Sounds
```lua
local sounds = {}

function loadSounds()
    sounds.jump = love.audio.newSource("assets/jump.wav", "static")
    sounds.music = love.audio.newSource("assets/music.mp3", "stream")
    sounds.music:setLooping(true)
end
```

## Testing

### 1. Unit Testing
Consider using a Lua testing framework like `busted` or `luaunit`.

### 2. Manual Testing
- Test on different screen resolutions
- Test with different frame rates
- Test input responsiveness
- Test memory usage over time

## Distribution

### 1. Creating .love Files
```bash
zip -9 -r game.love . -x "*.git*" "*.DS_Store*" "examples/*" "docs/*"
```

### 2. Building Executables
Use tools like:
- `love-release` for creating distributable packages
- `love-builder` for cross-platform builds

## Resources

- [Love2D Wiki](https://love2d.org/wiki/)
- [Love2D Forums](https://love2d.org/forums/)
- [Lua Reference Manual](https://www.lua.org/manual/5.4/)
- [Love2D Community Discord](https://discord.gg/love2d) 