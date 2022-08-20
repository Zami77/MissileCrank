local gfx <const> = playdate.graphics

class('Level').extends(gfx.sprite)

local levelMap = {
    "Level-01"
}

function Level:loadLevel()
    local levelImage = nil
    levelImage = gfx.image.new("images/levels/" .. levelMap[self.level])
    assert(levelImage)
    self:setImage(levelImage)
end

function Level:createCities(numCities)
    for i=1, numCities, 1 do
        self.cities[i] = City((screenWidth // numCities) * (i - 1) + 32)
        self.cities[i]:add()
    end
end

function Level:init(numCities, curLevel, x, y)
    x = x or screenWidth // 2
    y = y or screenHeight - 20
    self.level = curLevel or 1
    numCities = numCities or 5
    self.cities = {}

    Level.super.init(self)
    
    self:loadLevel()
    self:createCities(numCities)
    
    self:moveTo(x, y)
    self:add()
end


function nextLevel()
    self.level += 1
    self:loadLevel()
end
