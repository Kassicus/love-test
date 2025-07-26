-- src/ui.lua - UI module for displaying text and interface elements

local UI = {}

-- UI state
local uiState = {
    font = nil,
    colors = {
        text = {1, 1, 1, 1},
        background = {0, 0, 0, 0.5}
    }
}

-- Initialize UI
function UI.init()
    uiState.font = love.graphics.newFont(14)
    love.graphics.setFont(uiState.font)
end

-- Draw instructions
function UI.drawInstructions()
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print("Use WASD or Arrow Keys to move", 10, 10)
    love.graphics.print("Press ESC to quit", 10, 30)
end

-- Draw player position
function UI.drawPlayerPosition(x, y)
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print(string.format("Player Position: (%.0f, %.0f)", x, y), 10, 50)
end

-- Draw FPS counter
function UI.drawFPS()
    local fps = love.timer.getFPS()
    love.graphics.setColor(uiState.colors.text)
    love.graphics.print(string.format("FPS: %d", fps), love.graphics.getWidth() - 100, 10)
end

-- Draw a simple button (for future use)
function UI.drawButton(text, x, y, width, height, isHovered)
    local color = isHovered and {0.7, 0.7, 0.7, 1} or {0.5, 0.5, 0.5, 1}
    
    love.graphics.setColor(color)
    love.graphics.rectangle('fill', x, y, width, height)
    
    love.graphics.setColor(uiState.colors.text)
    local textWidth = uiState.font:getWidth(text)
    local textHeight = uiState.font:getHeight()
    love.graphics.print(text, x + (width - textWidth) / 2, y + (height - textHeight) / 2)
end

-- Check if a point is inside a rectangle
function UI.isPointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

return UI 