-- examples/angrybirds/bird.lua - Bird class

local Bird = {}
Bird.__index = Bird

function Bird.new(x, y, radius, color, world)
    local self = setmetatable({}, Bird)
    
    self.radius = radius
    self.color = color
    self.world = world
    self.x = x
    self.y = y
    self.dragX = 0
    self.dragY = 0
    self.isLaunched = false
    self.isInSlingshot = true
    self.body = nil
    self.fixture = nil
    
    -- Create physics body
    self:createPhysicsBody()
    
    return self
end

function Bird:createPhysicsBody()
    -- Create dynamic body
    self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
    
    -- Create circle shape
    local shape = love.physics.newCircleShape(self.radius)
    
    -- Create fixture with properties
    self.fixture = love.physics.newFixture(self.body, shape, 1)
    self.fixture:setRestitution(0.3) -- Bouncy
    self.fixture:setFriction(0.2)
    
    -- Set user data for collision detection
    self.fixture:setUserData({type = "bird", bird = self})
    
    -- If bird is in slingshot, make it kinematic (not affected by gravity)
    if self.isInSlingshot then
        self.body:setType("kinematic")
    end
end

function Bird:update(dt)
    if self.body then
        self.x, self.y = self.body:getPosition()
        
        -- Check if bird is off screen
        if self.y > 1000 then
            self:destroy()
        end
    end
end

function Bird:launch(velocityX, velocityY)
    if not self.body then return end
    
    -- Change body type to dynamic for physics
    self.body:setType("dynamic")
    
    -- Apply velocity directly
    self.body:setLinearVelocity(velocityX, velocityY)
    
    -- Mark as launched
    self.isLaunched = true
    self.isInSlingshot = false
end

function Bird:setDragPosition(dragX, dragY)
    self.dragX = dragX
    self.dragY = dragY
    
    -- Don't update the actual bird position while dragging
    -- The bird should stay in the slingshot until launched
    -- Only update the drag values for trajectory calculation
end

function Bird:getDragX()
    return self.dragX
end

function Bird:getDragY()
    return self.dragY
end

function Bird:getX()
    return self.x
end

function Bird:getY()
    return self.y
end

function Bird:getLaunched()
    return self.isLaunched
end

function Bird:getInSlingshot()
    return self.isInSlingshot
end

function Bird:setInSlingshot(inSlingshot)
    self.isInSlingshot = inSlingshot
    
    if self.body then
        if inSlingshot then
            -- Make kinematic when in slingshot (not affected by gravity)
            self.body:setType("kinematic")
            self.body:setLinearVelocity(0, 0)
            self.body:setAngularVelocity(0)
        else
            -- Make dynamic when not in slingshot
            self.body:setType("dynamic")
        end
    end
end

function Bird:reset(x, y)
    if self.body then
        self.body:setPosition(x, y)
        self.body:setLinearVelocity(0, 0)
        self.body:setAngularVelocity(0)
    end
    
    self.x = x
    self.y = y
    self.dragX = 0
    self.dragY = 0
    self.isLaunched = false
    self.isInSlingshot = true
end

function Bird:destroy()
    if self.body then
        self.body:destroy()
        self.body = nil
        self.fixture = nil
    end
end

function Bird:draw()
    if not self.body then return end
    
    local x, y = self.body:getPosition()
    local angle = self.body:getAngle()
    
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    
    -- Draw bird body
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', 0, 0, self.radius)
    
    -- Draw bird border
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('line', 0, 0, self.radius)
    
    -- Draw bird eye
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', -5, -5, 3)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('fill', -5, -5, 1.5)
    
    -- Draw bird beak
    love.graphics.setColor(1, 0.5, 0, 1)
    love.graphics.polygon('fill', 10, 0, 15, -3, 15, 3)
    
    love.graphics.pop()
end

return Bird 