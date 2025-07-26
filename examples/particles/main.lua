-- examples/particles/main.lua - Example demonstrating Love2D particle system

local particles = {}
local emitter = nil

function love.load()
    -- Create a particle system
    local particleSystem = love.graphics.newParticleSystem(love.graphics.newCanvas(1, 1))
    
    -- Configure the particle system
    particleSystem:setParticleLifetime(2, 4) -- Particles live for 2-4 seconds
    particleSystem:setLinearAcceleration(-50, -50, 50, 50) -- Random acceleration
    particleSystem:setColors(1, 1, 1, 1, 1, 0, 0, 0) -- Fade from white to red
    particleSystem:setSizes(2, 0) -- Start at size 2, shrink to 0
    particleSystem:setEmissionRate(100) -- Emit 100 particles per second
    particleSystem:setSpeed(50, 100) -- Random speed between 50-100
    particleSystem:setSpread(0.5) -- Spread angle in radians
    
    -- Start emitting particles
    particleSystem:start()
    
    -- Create emitter at mouse position
    emitter = {
        system = particleSystem,
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2
    }
    
    -- Set window title
    love.window.setTitle("Love2D Particle Example")
end

function love.update(dt)
    -- Update particle system
    emitter.system:update(dt)
    
    -- Move emitter to mouse position
    emitter.x = love.mouse.getX()
    emitter.y = love.mouse.getY()
    
    -- Set emitter position
    emitter.system:setPosition(emitter.x, emitter.y)
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw particles
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(emitter.system)
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Move your mouse to create particles!", 10, 10)
    love.graphics.print("Press ESC to quit", 10, 30)
    love.graphics.print("Press SPACE to toggle emission", 10, 50)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        -- Toggle particle emission
        if emitter.system:isActive() then
            emitter.system:stop()
        else
            emitter.system:start()
        end
    end
end 