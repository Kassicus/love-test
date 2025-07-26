-- examples/angrybirds/main.lua - Angry Birds game clone

-- Import modules
local Bird = require('bird')
local Castle = require('castle')
local Slingshot = require('slingshot')
local GameState = require('gameState')

-- Game variables
local birds = {}
local castle = nil
local slingshot = nil
local gameState = nil
local world = nil
local currentBird = nil
local isDragging = false
local dragStartX = 0
local dragStartY = 0
local trajectoryPoints = {}
local ground = nil
local debugMode = false

-- Game constants
local BIRD_RADIUS = 15
local BIRD_COLORS = {
    {0.8, 0.2, 0.2, 1}, -- Red
    {0.2, 0.8, 0.2, 1}, -- Green
    {0.2, 0.2, 0.8, 1}, -- Blue
    {0.8, 0.8, 0.2, 1}, -- Yellow
    {0.8, 0.2, 0.8, 1}  -- Purple
}

function love.load()
    -- Set window properties
    love.window.setTitle("Angry Birds")
    love.window.setMode(1200, 800)
    
    -- Initialize physics world
    world = love.physics.newWorld(0, 500, true)
    
    -- Set up collision callbacks
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    
    -- Create ground
    createGround()
    
    -- Initialize game objects
    gameState = GameState.new()
    slingshot = Slingshot.new(200, 600, world)
    castle = Castle.new(900, 600, world)
    
    -- Create birds
    createBirds()
    
    -- Set default font
    love.graphics.setFont(love.graphics.newFont(16))
end

function love.update(dt)
    -- Update physics world
    world:update(dt)
    
    -- Update game objects
    slingshot:update(dt)
    castle:update(dt)
    
    -- Update birds
    for i, bird in ipairs(birds) do
        bird:update(dt)
    end
    
    -- Update trajectory
    if isDragging and currentBird then
        updateTrajectory()
    end
    
    -- Check win/lose conditions
    checkGameState()
end

function love.draw()
    -- Clear screen
    love.graphics.setColor(0.5, 0.8, 1, 1) -- Sky blue
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    -- Draw ground
    love.graphics.setColor(0.3, 0.6, 0.2, 1) -- Green
    love.graphics.rectangle('fill', 0, 700, love.graphics.getWidth(), 100)
    
    -- Draw castle
    castle:draw()
    
    -- Draw slingshot
    slingshot:draw()
    
    -- Draw birds
    for i, bird in ipairs(birds) do
        bird:draw()
    end
    
    -- Draw trajectory
    if isDragging and #trajectoryPoints > 1 then
        drawTrajectory()
    end
    
    -- Draw UI
    drawUI()
    
    -- Draw debug info if enabled
    if debugMode then
        drawDebugInfo()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState:isPlaying() then
        -- Check if clicking on a bird
        for i, bird in ipairs(birds) do
            if bird:getInSlingshot() and not bird:getLaunched() then
                local birdX, birdY = bird:getX(), bird:getY()
                local distance = math.sqrt((x - birdX)^2 + (y - birdY)^2)
                if distance <= BIRD_RADIUS then
                    currentBird = bird
                    isDragging = true
                    dragStartX = x
                    dragStartY = y
                    break
                end
            end
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 and isDragging and currentBird then
        -- Calculate drag vector (from slingshot to mouse release point)
        local slingshotX = slingshot:getX()
        local slingshotY = slingshot:getY()
        local dragX = x - slingshotX  -- Positive = right, Negative = left
        local dragY = y - slingshotY  -- Positive = down, Negative = up
        
        -- Calculate power based on drag distance
        local dragDistance = math.sqrt(dragX^2 + dragY^2)
        local power = dragDistance * 2.0  -- Much higher power scaling
        
        -- Position bird at slingshot before launching
        currentBird:reset(slingshotX, slingshotY)
        
        -- Launch bird in OPPOSITE direction of drag
        currentBird:launch(-dragX * 2.0, -dragY * 2.0)
        
        currentBird = nil
        isDragging = false
        trajectoryPoints = {}
        
        -- Move to next bird
        gameState:nextBird()
        
        -- Move next bird into slingshot
        moveNextBirdToSlingshot()
    end
end

function love.mousemoved(x, y)
    if isDragging and currentBird then
        -- Update bird position while dragging
        local dragX = dragStartX - x
        local dragY = dragStartY - y
        local maxDrag = 100
        
        dragX = math.max(-maxDrag, math.min(maxDrag, dragX))
        dragY = math.max(-maxDrag, math.min(maxDrag, dragY))
        
        currentBird:setDragPosition(dragX, dragY)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        gameState:restart()
        resetGame()
    elseif key == 'd' then
        debugMode = not debugMode
    end
end

-- Collision callbacks
function beginContact(a, b, coll)
    local userDataA = a:getUserData()
    local userDataB = b:getUserData()
    
    if userDataA and userDataB then
        -- Bird hitting block
        if userDataA.type == "bird" and userDataB.type == "block" then
            castle:damageBlock(userDataB.block)
        elseif userDataA.type == "block" and userDataB.type == "bird" then
            castle:damageBlock(userDataA.block)
        end
        
        -- Bird hitting pig
        if userDataA.type == "bird" and userDataB.type == "pig" then
            castle:damagePig(userDataB.pig)
        elseif userDataA.type == "pig" and userDataB.type == "bird" then
            castle:damagePig(userDataA.pig)
        end
    end
end

function endContact(a, b, coll)
    -- Not needed for this game
end

function preSolve(a, b, coll)
    -- Not needed for this game
end

function postSolve(a, b, coll, normalImpulse, tangentImpulse)
    -- Not needed for this game
end

function createGround()
    -- Create ground body
    ground = {}
    ground.body = love.physics.newBody(world, 600, 750, "static")
    ground.shape = love.physics.newRectangleShape(1200, 100)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)
    ground.fixture:setFriction(0.3)
end

function moveNextBirdToSlingshot()
    local currentIndex = gameState:getCurrentBirdIndex()
    if currentIndex <= #birds then
        local bird = birds[currentIndex]
        if bird then
            -- Move bird to slingshot position
            local slingshotX = slingshot:getX()
            local slingshotY = slingshot:getY()
            bird:reset(slingshotX, slingshotY)
            bird:setInSlingshot(true)
        end
    end
end

function createBirds()
    birds = {}
    local slingshotX = slingshot:getX()
    local slingshotY = slingshot:getY()
    
    for i = 1, 5 do
        -- Position birds in a queue to the left of the slingshot
        local birdX = slingshotX - 30 - (i - 1) * 35
        local birdY = slingshotY
        local bird = Bird.new(birdX, birdY, BIRD_RADIUS, BIRD_COLORS[i], world)
        
        -- Only the first bird should be in the slingshot
        if i == 1 then
            bird:setInSlingshot(true)
        else
            bird:setInSlingshot(false)
        end
        
        table.insert(birds, bird)
    end
end

function updateTrajectory()
    if not currentBird then return end
    
    trajectoryPoints = {}
    local slingshotX = slingshot:getX()
    local slingshotY = slingshot:getY()
    
    -- Get current mouse position
    local mouseX, mouseY = love.mouse.getPosition()
    
    -- Calculate drag vector (from slingshot to current mouse position)
    local dragX = mouseX - slingshotX
    local dragY = mouseY - slingshotY
    
    -- Calculate velocity (opposite direction of drag)
    local velocityX = -dragX * 2.0
    local velocityY = -dragY * 2.0
    
    for i = 1, 50 do
        local t = i * 0.1
        local x = slingshotX + velocityX * t
        local y = slingshotY + velocityY * t + 0.5 * 500 * t * t -- Gravity
        
        table.insert(trajectoryPoints, {x = x, y = y})
        
        -- Stop if trajectory goes off screen
        if x < 0 or x > love.graphics.getWidth() or y > love.graphics.getHeight() then
            break
        end
    end
end

function drawTrajectory()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineWidth(2)
    
    for i = 1, #trajectoryPoints - 1 do
        love.graphics.line(
            trajectoryPoints[i].x, trajectoryPoints[i].y,
            trajectoryPoints[i + 1].x, trajectoryPoints[i + 1].y
        )
    end
    
    love.graphics.setLineWidth(1)
end

function checkGameState()
    -- Check if all pigs are destroyed
    if castle:allPigsDestroyed() then
        gameState:win()
    end
    
    -- Check if all birds are used and no more are in slingshot
    local birdsInSlingshot = 0
    for i, bird in ipairs(birds) do
        if bird:getInSlingshot() and not bird:getLaunched() then
            birdsInSlingshot = birdsInSlingshot + 1
        end
    end
    
    if birdsInSlingshot == 0 and gameState:getCurrentBirdIndex() > #birds then
        gameState:lose()
    end
end

function resetGame()
    -- Reset birds
    local slingshotX = slingshot:getX()
    local slingshotY = slingshot:getY()
    
    for i, bird in ipairs(birds) do
        local birdX = slingshotX - 30 - (i - 1) * 35
        bird:reset(birdX, slingshotY)
        
        -- Only the first bird should be in the slingshot
        if i == 1 then
            bird:setInSlingshot(true)
        else
            bird:setInSlingshot(false)
        end
    end
    
    -- Reset castle
    castle:reset()
    
    -- Reset slingshot
    slingshot:reset()
    
    -- Reset game state
    currentBird = nil
    isDragging = false
    trajectoryPoints = {}
end

function drawUI()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw title
    love.graphics.print("Angry Birds", 20, 20)
    
    -- Draw bird counter
    local remainingBirds = gameState:getRemainingBirds()
    love.graphics.print("Birds: " .. remainingBirds, 20, 50)
    
    -- Draw game state messages
    if gameState:isWon() then
        love.graphics.setColor(0.5, 1, 0.5, 1)
        love.graphics.print("YOU WIN!", love.graphics.getWidth()/2 - 50, 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press R to restart", love.graphics.getWidth()/2 - 70, 50)
    elseif gameState:isLost() then
        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.print("YOU LOSE!", love.graphics.getWidth()/2 - 50, 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Press R to restart", love.graphics.getWidth()/2 - 70, 50)
    end
    
    -- Draw controls
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print("Click and drag birds to launch | R: Restart | D: Debug", 20, love.graphics.getHeight() - 30)
end

function drawDebugInfo()
    love.graphics.setColor(1, 1, 0, 1)
    
    -- Draw mouse position
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.print("Mouse: (" .. mouseX .. ", " .. mouseY .. ")", 10, love.graphics.getHeight() - 80)
    
    -- Draw bird positions and states
    for i, bird in ipairs(birds) do
        local x, y = bird:getX(), bird:getY()
        local inSlingshot = bird:getInSlingshot()
        local launched = bird:getLaunched()
        
        love.graphics.print("Bird " .. i .. ": (" .. math.floor(x) .. ", " .. math.floor(y) .. ") Slingshot: " .. tostring(inSlingshot) .. " Launched: " .. tostring(launched), 10, love.graphics.getHeight() - 60 + (i-1) * 15)
        
        -- Highlight birds in slingshot
        if inSlingshot and not launched then
            love.graphics.setColor(0, 1, 0, 0.3)
            love.graphics.circle('fill', x, y, BIRD_RADIUS + 5)
            love.graphics.setColor(1, 1, 0, 1)
        end
    end
    
    -- Draw pig count
    local pigCount = castle:getPigCount()
    love.graphics.print("Pigs remaining: " .. pigCount, 10, love.graphics.getHeight() - 120)
end 