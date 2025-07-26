-- examples/minesweeper/board.lua - Board class for Minesweeper

local Board = {}
Board.__index = Board

function Board.new(width, height, mineCount, cellSize)
    local self = setmetatable({}, Board)
    
    self.width = width
    self.height = height
    self.mineCount = mineCount
    self.cellSize = cellSize
    self.cells = {}
    self.mines = {}
    self.flaggedCells = {}
    self.revealedCells = {}
    self.firstClick = true
    
    self:initializeBoard()
    
    return self
end

function Board:initializeBoard()
    -- Initialize all cells
    for x = 1, self.width do
        self.cells[x] = {}
        for y = 1, self.height do
            self.cells[x][y] = {
                isMine = false,
                neighborMines = 0
            }
        end
    end
end

function Board:placeMines(firstX, firstY)
    local minesPlaced = 0
    local attempts = 0
    local maxAttempts = self.width * self.height * 2
    
    while minesPlaced < self.mineCount and attempts < maxAttempts do
        local x = math.random(1, self.width)
        local y = math.random(1, self.height)
        
        -- Don't place mine on first click or if already a mine
        if (x ~= firstX or y ~= firstY) and not self.cells[x][y].isMine then
            self.cells[x][y].isMine = true
            table.insert(self.mines, {x = x, y = y})
            minesPlaced = minesPlaced + 1
        end
        
        attempts = attempts + 1
    end
    
    -- Calculate neighbor mine counts
    self:calculateNeighborMines()
end

function Board:calculateNeighborMines()
    for x = 1, self.width do
        for y = 1, self.height do
            if not self.cells[x][y].isMine then
                local count = 0
                
                -- Check all 8 neighbors
                for dx = -1, 1 do
                    for dy = -1, 1 do
                        if dx ~= 0 or dy ~= 0 then
                            local nx, ny = x + dx, y + dy
                            if nx >= 1 and nx <= self.width and ny >= 1 and ny <= self.height then
                                if self.cells[nx][ny].isMine then
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
                
                self.cells[x][y].neighborMines = count
            end
        end
    end
end

function Board:revealCell(x, y)
    -- Place mines on first click (to avoid clicking mine first)
    if self.firstClick then
        self:placeMines(x, y)
        self.firstClick = false
    end
    
    -- Check if cell is already revealed or flagged
    if self:isRevealed(x, y) or self:isFlagged(x, y) then
        return nil
    end
    
    -- Check if it's a mine
    if self.cells[x][y].isMine then
        return "mine"
    end
    
    -- Reveal the cell
    self:revealCellRecursive(x, y)
    
    -- Check for win condition
    if self:checkWinCondition() then
        return "win"
    end
    
    return nil
end

function Board:revealCellRecursive(x, y)
    -- Mark cell as revealed
    self.revealedCells[x .. "," .. y] = true
    
    -- If cell has no neighbor mines, reveal neighbors recursively
    if self.cells[x][y].neighborMines == 0 then
        for dx = -1, 1 do
            for dy = -1, 1 do
                if dx ~= 0 or dy ~= 0 then
                    local nx, ny = x + dx, y + dy
                    if nx >= 1 and nx <= self.width and ny >= 1 and ny <= self.height then
                        if not self:isRevealed(nx, ny) and not self:isFlagged(nx, ny) then
                            self:revealCellRecursive(nx, ny)
                        end
                    end
                end
            end
        end
    end
end

function Board:toggleFlag(x, y)
    if not self:isRevealed(x, y) then
        local key = x .. "," .. y
        if self.flaggedCells[key] then
            self.flaggedCells[key] = nil
        else
            self.flaggedCells[key] = true
        end
    end
end

function Board:isRevealed(x, y)
    return self.revealedCells[x .. "," .. y] == true
end

function Board:isFlagged(x, y)
    return self.flaggedCells[x .. "," .. y] == true
end

function Board:checkWinCondition()
    local revealedCount = 0
    for _ in pairs(self.revealedCells) do
        revealedCount = revealedCount + 1
    end
    
    -- Win if all non-mine cells are revealed
    return revealedCount == (self.width * self.height - self.mineCount)
end

function Board:getRemainingMines()
    local flaggedCount = 0
    for _ in pairs(self.flaggedCells) do
        flaggedCount = flaggedCount + 1
    end
    
    return self.mineCount - flaggedCount
end

function Board:revealAllMines()
    for _, mine in ipairs(self.mines) do
        self.revealedCells[mine.x .. "," .. mine.y] = true
    end
end

function Board:flagAllMines()
    for _, mine in ipairs(self.mines) do
        self.flaggedCells[mine.x .. "," .. mine.y] = true
    end
end

function Board:reset()
    self.cells = {}
    self.mines = {}
    self.flaggedCells = {}
    self.revealedCells = {}
    self.firstClick = true
    
    self:initializeBoard()
end

function Board:draw()
    local boardX = 20
    local boardY = 60
    
    for x = 1, self.width do
        for y = 1, self.height do
            local screenX = boardX + (x - 1) * self.cellSize
            local screenY = boardY + (y - 1) * self.cellSize
            
            self:drawCell(screenX, screenY, x, y)
        end
    end
end

function Board:drawCell(screenX, screenY, gridX, gridY)
    local cell = self.cells[gridX][gridY]
    local isRevealed = self:isRevealed(gridX, gridY)
    local isFlagged = self:isFlagged(gridX, gridY)
    
    -- Draw cell background
    if isRevealed then
        if cell.isMine then
            love.graphics.setColor(1, 0, 0, 1) -- Red for mine
        else
            love.graphics.setColor(0.8, 0.8, 0.8, 1) -- Light gray for revealed
        end
    else
        love.graphics.setColor(0.6, 0.6, 0.6, 1) -- Dark gray for hidden
    end
    
    love.graphics.rectangle('fill', screenX, screenY, self.cellSize - 1, self.cellSize - 1)
    
    -- Draw border
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle('line', screenX, screenY, self.cellSize - 1, self.cellSize - 1)
    
    -- Draw cell content
    if isFlagged then
        -- Draw flag
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("🚩", screenX + 5, screenY + 2)
    elseif isRevealed then
        if cell.isMine then
            -- Draw mine
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print("💣", screenX + 5, screenY + 2)
        elseif cell.neighborMines > 0 then
            -- Draw number
            local colors = {
                [1] = {0, 0, 1, 1},   -- Blue
                [2] = {0, 0.5, 0, 1}, -- Green
                [3] = {1, 0, 0, 1},   -- Red
                [4] = {0, 0, 0.5, 1}, -- Dark Blue
                [5] = {0.5, 0, 0, 1}, -- Dark Red
                [6] = {0, 0.5, 0.5, 1}, -- Teal
                [7] = {0, 0, 0, 1},   -- Black
                [8] = {0.5, 0.5, 0.5, 1} -- Gray
            }
            
            love.graphics.setColor(colors[cell.neighborMines])
            love.graphics.print(tostring(cell.neighborMines), screenX + 8, screenY + 5)
        end
    end
end

return Board 