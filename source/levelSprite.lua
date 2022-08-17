local gfx <const> = playdate.graphics

class('LevelSprite').extends(playdate.graphics.sprite)

local levelMap = {
    "Level-01"
}

function LevelSprite:init(curLevel, x, y)
    x = x or screenWidth // 2
    y = y or screenHeight - 20
    curLevel = curLevel or 1

    LevelSprite.super.init(self)

    local levelImage = nil
    levelImage = gfx.image.new("images/levels/" .. levelMap[curLevel])
    assert(levelImage)

    self:setImage(levelImage)
    self:moveTo(x, y)
    self:add()
    
end
