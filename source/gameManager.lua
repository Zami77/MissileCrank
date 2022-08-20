class('GameManager').extends()

local gfx <const> = playdate.graphics
local backgroundManager = nil
local levelManager = nil
local target = nil
local spawner = nil


function GameManager:init()
    -- Set Background
    backgroundManager = Background()
    
    -- Set Level
    levelManager = Level()

    -- Set Target
    target = Target()
    
    spawner = EnemySpawner()
    spawner:startSpawner()
end
