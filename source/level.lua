local gfx <const> = playdate.graphics
local pd <const> = playdate

class('Level').extends(gfx.sprite)

local levelMap = {
    "Level-01"
}

local backgroundMap = {
    "DefaultBackground"
}

function Level:loadLevel()
    local levelImage = nil
    levelImage = gfx.image.new("images/levels/" .. levelMap[1])
    assert(levelImage)
    self:setImage(levelImage)
end

function Level:createCities(numCities)
    for i=1, numCities, 1 do
        self.cities[i] = City((screenWidth // numCities) * (i - 1) + 32)
        self.cities[i]:add()
    end
end

function Level:setLevelBackground()
    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/" .. backgroundMap[1])
    assert(backgroundImage)
    
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
        end
    )
end

function Level:init(gameManager, curLevel, cities, levelLength, x, y)
    x = x or screenWidth // 2
    y = y or screenHeight - 20
    levelLength = levelLength or 30
    self.level = curLevel or 1
    local numCities = 5
    self.cities = cities or {}
    self.gameManager = gameManager

    Level.super.init(self)
    
    self:loadLevel()
    if not self.cities then
        self:createCities(numCities)
    end
    self:createCities(numCities)
    
    self:moveTo(x, y)
    self:add()
    
    self:setLevelBackground()

    self.levelTimer = pd.timer.new(secondsToMs(levelLength))
end

function Level:areCitiesAlive()
    local destroyedCities = 0
    for i=1, #self.cities, 1 do
        if not self.cities[i]:isActive() then
            destroyedCities += 1
        end
    end

    return destroyedCities < #self.cities
end

function Level:cleanup()
    self.gameManager:setCities(self.cities)
    for i=1, #self.cities, 1 do
        self.cities[i]:remove()
    end

end

function Level:update()
    if not self:areCitiesAlive() then
        self:cleanup()
        self.gameManager:setupGameOver()
    end

    if self.levelTimer.timeLeft == 0 then
        self:cleanup()
        self.gameManager:setupMainMenu()
    end
end

