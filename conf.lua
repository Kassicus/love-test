-- conf.lua - Love2D configuration file
-- This file is optional but useful for configuring your game

function love.conf(t)
    -- Game information
    t.identity = "love-test"                    -- Name of the save directory
    t.version = "11.5"                          -- Love2D version this game was made for
    t.console = true                            -- Enable console output (useful for debugging)
    
    -- Window settings
    t.window.title = "Love2D Test Game"         -- Window title
    t.window.icon = nil                         -- Filepath to an image to use as the window's icon
    t.window.width = 800                        -- Window width
    t.window.height = 600                       -- Window height
    t.window.minwidth = 400                     -- Minimum window width
    t.window.minheight = 300                    -- Minimum window height
    t.window.resizable = true                   -- Let the window be user-resizable
    t.window.fullscreen = false                 -- Enable fullscreen
    t.window.fullscreentype = "desktop"         -- Standard fullscreen or desktop fullscreen
    t.window.vsync = true                       -- Enable vertical sync
    t.window.msaa = 0                           -- Number of samples to use with multi-sampled antialiasing
    t.window.depth = nil                        -- Number of bits per sample in the depth buffer
    t.window.stencil = nil                      -- Number of bits per sample in the stencil buffer
    t.window.display = 1                        -- Index of the monitor to show the window in
    t.window.highdpi = false                    -- Enable high-dpi mode for the window on a Retina display
    t.window.usedpiscale = true                 -- Enable automatic DPI scaling
    t.window.x = nil                            -- The x-coordinate of the window's position in the specified display
    t.window.y = nil                            -- The y-coordinate of the window's position in the specified display
    
    -- Modules to load
    t.modules.audio = true                      -- Enable the audio module
    t.modules.data = true                       -- Enable the data module
    t.modules.event = true                      -- Enable the event module
    t.modules.font = true                       -- Enable the font module
    t.modules.graphics = true                   -- Enable the graphics module
    t.modules.image = true                      -- Enable the image module
    t.modules.joystick = true                   -- Enable the joystick module
    t.modules.keyboard = true                   -- Enable the keyboard module
    t.modules.math = true                       -- Enable the math module
    t.modules.mouse = true                      -- Enable the mouse module
    t.modules.physics = true                    -- Enable the physics module
    t.modules.sound = true                      -- Enable the sound module
    t.modules.system = true                     -- Enable the system module
    t.modules.thread = true                     -- Enable the thread module
    t.modules.timer = true                      -- Enable the timer module
    t.modules.touch = true                      -- Enable the touch module
    t.modules.video = true                      -- Enable the video module
    t.modules.window = true                     -- Enable the window module
end 