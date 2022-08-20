local gfx <const> = playdate.graphics

class('Background').extends(playdate.graphics.sprite)

local backgroundMap = {
    [0] = "DefaultBackground"
}

function Background:init(curBackground)
    curBackground = curBackground or 0

    Background.super.init(self)

    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/" .. backgroundMap[curBackground])
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
            
        end
    )
end