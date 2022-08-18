class('GameManager').extends()

local gfx <const> = playdate.graphics
local curBackground = nil
local curLevel = nil
local target = nil
local enemySpawnTimer = nil
local enemySpawnRate = 5 * 1000 -- 5 seconds

function GameManager:init()
    -- Set Background
    curBackground = BackgroundSprite()
    
    -- Set Level
    curLevel = LevelSprite(1)

    -- Set Target
    target = Target()
    
    enemySpawner()
end
