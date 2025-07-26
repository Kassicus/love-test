-- examples/angrybirds/castle.lua - Castle class

local Castle = {}
Castle.__index = Castle

function Castle.new(x, y, world)
    local self = setmetatable({}, Castle)
    
    self.x = x
    self.y = y
    self.world = world
    self.blocks = {}
    self.pigs = {}
    
    -- Create castle structure
    self:createCastle()
    
    return self
end

function Castle:createCastle()
    -- Create ground blocks
    self:createBlock(self.x, self.y + 100, 60, 20, "stone")
    self:createBlock(self.x + 80, self.y + 100, 60, 20, "stone")
    self:createBlock(self.x - 80, self.y + 100, 60, 20, "stone")
    
    -- Create base structure
    self:createBlock(self.x, self.y + 60, 60, 20, "wood")
    self:createBlock(self.x + 80, self.y + 60, 60, 20, "wood")
    self:createBlock(self.x - 80, self.y + 60, 60, 20, "wood")
    
    -- Create middle structure
    self:createBlock(self.x, self.y + 20, 60, 20, "wood")
    self:createBlock(self.x + 80, self.y + 20, 60, 20, "wood")
    self:createBlock(self.x - 80, self.y + 20, 60, 20, "wood")
    
    -- Create top structure
    self:createBlock(self.x, self.y - 20, 60, 20, "wood")
    self:createBlock(self.x + 80, self.y - 20, 60, 20, "wood")
    self:createBlock(self.x - 80, self.y - 20, 60, 20, "wood")
    
    -- Create roof
    self:createBlock(self.x, self.y - 60, 60, 20, "stone")
    self:createBlock(self.x + 80, self.y - 60, 60, 20, "stone")
    self:createBlock(self.x - 80, self.y - 60, 60, 20, "stone")
    
    -- Create pigs
    self:createPig(self.x, self.y + 40, 20) -- Middle pig
    self:createPig(self.x + 80, self.y + 40, 20) -- Right pig
    self:createPig(self.x - 80, self.y + 40, 20) -- Left pig
    self:createPig(self.x, self.y, 20) -- Top pig
end

function Castle:createBlock(x, y, width, height, material)
    local block = {
        x = x,
        y = y,
        width = width,
        height = height,
        material = material,
        body = nil,
        fixture = nil,
        health = material == "stone" and 3 or 1
    }
    
    -- Create physics body
    block.body = love.physics.newBody(self.world, x, y, "dynamic")
    local shape = love.physics.newRectangleShape(width, height)
    block.fixture = love.physics.newFixture(block.body, shape, 1)
    block.fixture:setRestitution(0.1)
    block.fixture:setFriction(0.3)
    
    -- Set user data for collision detection
    block.fixture:setUserData({type = "block", block = block})
    
    table.insert(self.blocks, block)
end

function Castle:createPig(x, y, radius)
    local pig = {
        x = x,
        y = y,
        radius = radius,
        body = nil,
        fixture = nil,
        health = 2
    }
    
    -- Create physics body
    pig.body = love.physics.newBody(self.world, x, y, "dynamic")
    local shape = love.physics.newCircleShape(radius)
    pig.fixture = love.physics.newFixture(pig.body, shape, 1)
    pig.fixture:setRestitution(0.2)
    pig.fixture:setFriction(0.4)
    
    -- Set user data for collision detection
    pig.fixture:setUserData({type = "pig", pig = pig})
    
    table.insert(self.pigs, pig)
end

function Castle:update(dt)
    -- Update blocks
    for i = #self.blocks, 1, -1 do
        local block = self.blocks[i]
        if block.body then
            block.x, block.y = block.body:getPosition()
            
            -- Remove blocks that fall off screen
            if block.y > 1000 then
                block.body:destroy()
                table.remove(self.blocks, i)
            end
        end
    end
    
    -- Update pigs
    for i = #self.pigs, 1, -1 do
        local pig = self.pigs[i]
        if pig.body then
            pig.x, pig.y = pig.body:getPosition()
            
            -- Remove pigs that fall off screen
            if pig.y > 1000 then
                pig.body:destroy()
                table.remove(self.pigs, i)
            end
        end
    end
end

function Castle:damageBlock(block)
    block.health = block.health - 1
    if block.health <= 0 then
        block.body:destroy()
        -- Remove from blocks list
        for i, b in ipairs(self.blocks) do
            if b == block then
                table.remove(self.blocks, i)
                break
            end
        end
    end
end

function Castle:damagePig(pig)
    pig.health = pig.health - 1
    if pig.health <= 0 then
        pig.body:destroy()
        -- Remove from pigs list
        for i, p in ipairs(self.pigs) do
            if p == pig then
                table.remove(self.pigs, i)
                break
            end
        end
    end
end

function Castle:allPigsDestroyed()
    return #self.pigs == 0
end

function Castle:getPigCount()
    return #self.pigs
end

function Castle:reset()
    -- Destroy existing blocks and pigs
    for _, block in ipairs(self.blocks) do
        if block.body then
            block.body:destroy()
        end
    end
    
    for _, pig in ipairs(self.pigs) do
        if pig.body then
            pig.body:destroy()
        end
    end
    
    self.blocks = {}
    self.pigs = {}
    
    -- Recreate castle
    self:createCastle()
end

function Castle:draw()
    -- Draw blocks
    for _, block in ipairs(self.blocks) do
        if block.body then
            local x, y = block.body:getPosition()
            local angle = block.body:getAngle()
            
            love.graphics.push()
            love.graphics.translate(x, y)
            love.graphics.rotate(angle)
            
            -- Draw block based on material
            if block.material == "stone" then
                love.graphics.setColor(0.5, 0.5, 0.5, 1)
            else
                love.graphics.setColor(0.6, 0.4, 0.2, 1)
            end
            
            love.graphics.rectangle('fill', -block.width/2, -block.height/2, block.width, block.height)
            
            -- Draw border
            love.graphics.setColor(0.3, 0.3, 0.3, 1)
            love.graphics.rectangle('line', -block.width/2, -block.height/2, block.width, block.height)
            
            love.graphics.pop()
        end
    end
    
    -- Draw pigs
    for _, pig in ipairs(self.pigs) do
        if pig.body then
            local x, y = pig.body:getPosition()
            local angle = pig.body:getAngle()
            
            love.graphics.push()
            love.graphics.translate(x, y)
            love.graphics.rotate(angle)
            
            -- Draw pig body
            love.graphics.setColor(0.2, 0.8, 0.2, 1)
            love.graphics.circle('fill', 0, 0, pig.radius)
            
            -- Draw pig border
            love.graphics.setColor(0.1, 0.6, 0.1, 1)
            love.graphics.circle('line', 0, 0, pig.radius)
            
            -- Draw pig eyes
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.circle('fill', -5, -3, 2)
            love.graphics.circle('fill', 5, -3, 2)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.circle('fill', -5, -3, 1)
            love.graphics.circle('fill', 5, -3, 1)
            
            -- Draw pig nose
            love.graphics.setColor(1, 0.5, 0.5, 1)
            love.graphics.circle('fill', 0, 2, 3)
            
            love.graphics.pop()
        end
    end
end

return Castle 