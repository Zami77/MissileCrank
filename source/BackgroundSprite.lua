local gfx <const> = playdate.graphics

class('BackgroundSprite').extends(playdate.graphics.sprite)

local backgroundMap = {
    [0] = "DefaultBackground"
}

function BackgroundSprite:init(curBackground)
    curBackground = curBackground or 0

    BackgroundSprite.super.init(self)

    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/" .. backgroundMap[curBackground])
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
            
        end
    )
end