local gfx <const> = playdate.graphics
local backgroundImage = nil
local levelImage = nil
local levelSprite = nil

function gameManagerInit()
    -- Set Background
    backgroundImage = gfx.image.new("images/backgrounds/DefaultBackground")
    assert(backgroundImage)
    
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
            
        end
    )

    -- Set Level
    local curLevel = LevelSprite(1)

end