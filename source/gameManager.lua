class('GameManager').extends()

local gfx <const> = playdate.graphics
local backgroundImage = nil
local levelImage = nil
local levelSprite = nil

function GameManager:init()
    -- Set Background
    local curBackground = BackgroundSprite()
    
    -- Set Level
    local curLevel = LevelSprite(1)

end

