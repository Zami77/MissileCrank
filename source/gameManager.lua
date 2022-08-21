class('GameManager').extends()

local gfx <const> = playdate.graphics
local backgroundManager = nil
local levelManager = nil
local target = nil
local spawner = nil
local ui = nil


function GameManager:init()
    backgroundManager = Background()
    levelManager = Level()
    target = Target()
    
    spawner = EnemySpawner()
    spawner:startSpawner()
    
    ui = UIOverlay(target)
end

function GameManager:update()
    ui:update()
    print("Score: " .. target:getScore())
    print("Scraps: " .. target:getScraps())
end
