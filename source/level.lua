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
    self.cities = {}

    for i=1, numCities, 1 do
        self.cities[i] = City((screenWidth // numCities) * (i - 1) + 32)
        self.cities[i]:add()
    end
end

function Level:loadCities()
    for i=1, #self.cities, 1 do
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

    self.cities = cities or nil
    self.gameManager = gameManager

    Level.super.init(self)
    
    self:loadLevel()

    if not self.cities then
        self:createCities(numCities)
    else
        self:loadCities()
    end
    
    self:moveTo(x, y)
    self:add()
    
    self:setLevelBackground()

    self.levelTimer = pd.timer.new(secondsToMs(levelLength))

    local endLevelBufferLength = 3
    self.endLevelBufferTimer = pd.timer.new(secondsToMs(endLevelBufferLength))
    self.endLevelBufferTimer:pause()
    self.spawnersStopped = false
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

function Level:levelSuccess()
    self:cleanup()
    self.gameManager:levelSuccess()
end

function Level:levelFailure()
    self:cleanup()
    self.gameManager:levelFailure()
end

function Level:update()
    if not self:areCitiesAlive() then
        self:levelFailure()
    end

    if self.endLevelBufferTimer.timeLeft == 0 then
        self:levelSuccess()
    end

    if self.levelTimer.timeLeft <= 3000 then
        gfx.pushContext()
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.drawTextInRect("Level Ending!", screenWidth // 2 - 100, screenHeight // 2, 200, gfx.getSystemFont():getHeight(), nil, nil, kTextAlignment.center)
        gfx.popContext()

        if not self.spawnersStopped then
            self.gameManager:stopAllSpawners()
            self.spawnersStopped = true
        end
    end

    if self.levelTimer.timeLeft == 0 then
        if not self.gameManager:areThereEnemies() then
            self.endLevelBufferTimer:start()
        end
    end
end

