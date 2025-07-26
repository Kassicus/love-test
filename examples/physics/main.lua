-- examples/physics/main.lua - Example demonstrating Love2D physics system

local world = nil
local bodies = {}
local joints = {}

function love.load()
    -- Create a new world with gravity
    world = love.physics.newWorld(0, 300, true)
    
    -- Create ground
    local ground = {}
    ground.body = love.physics.newBody(world, 400, 550, "static")
    ground.shape = love.physics.newRectangleShape(800, 100)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    table.insert(bodies, ground)
    
    -- Create some boxes
    for i = 1, 5 do
        local box = {}
        box.body = love.physics.newBody(world, 200 + i * 80, 100, "dynamic")
        box.shape = love.physics.newRectangleShape(40, 40)
        box.fixture = love.physics.newFixture(box.body, box.shape, 1)
        table.insert(bodies, box)
    end
    
    -- Create a circle
    local circle = {}
    circle.body = love.physics.newBody(world, 400, 50, "dynamic")
    circle.shape = love.physics.newCircleShape(20)
    circle.fixture = love.physics.newFixture(circle.body, circle.shape, 1)
    table.insert(bodies, circle)
    
    -- Set window title
    love.window.setTitle("Love2D Physics Example")
end

function love.update(dt)
    -- Update physics world
    world:update(dt)
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw all bodies
    for i, body in ipairs(bodies) do
        local x, y = body.body:getPosition()
        local angle = body.body:getAngle()
        
        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.rotate(angle)
        
        if body.shape:getType() == "polygon" then
            love.graphics.setColor(0.8, 0.6, 0.9, 1)
            love.graphics.polygon('fill', body.body:getWorldPoints(body.shape:getPoints()))
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.polygon('line', body.body:getWorldPoints(body.shape:getPoints()))
        elseif body.shape:getType() == "circle" then
            love.graphics.setColor(0.9, 0.7, 0.5, 1)
            love.graphics.circle('fill', 0, 0, body.shape:getRadius())
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.circle('line', 0, 0, body.shape:getRadius())
        end
        
        love.graphics.pop()
    end
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Physics simulation running!", 10, 10)
    love.graphics.print("Press SPACE to add boxes", 10, 30)
    love.graphics.print("Press ESC to quit", 10, 50)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        -- Add a new box when space is pressed
        local box = {}
        box.body = love.physics.newBody(world, love.mouse.getX(), love.mouse.getY(), "dynamic")
        box.shape = love.physics.newRectangleShape(30, 30)
        box.fixture = love.physics.newFixture(box.body, box.shape, 1)
        table.insert(bodies, box)
    end
end 