class('GameManager').extends()

local gfx <const> = playdate.graphics

local gameStates = {
    MAIN_MENU = 0,
    SHOP_MENU = 1,
    LEVEL = 2,
    GAME_OVER = 3
}
local backgroundManager = nil
local levelManager = nil
local target = nil
local spawner = nil
local ui = nil

local startSpawnRate = 5000
local startTargetSpeed = 3
local startMaxMissiles = 1
local startMissileSpeed = 4

function GameManager:init()
    GameManager.super.init(self)
    
    self.score = 0
    self.scraps = 0
    self.curLevel = 1
    self.state = gameStates.MAIN_MENU
    self.cities = nil
    self.spawnRate = startSpawnRate
    self.targetSpeed = startTargetSpeed
    self.maxMissiles = startMaxMissiles
    self.missileSpeed = startMissileSpeed

    self.highScore = 0

    self.gameOverScore = self.score
    self.gameOverScraps = self.scraps
    self.gameOverLevel = self.curLevel
        
    self.levelManager = nil
    self.target = nil
    self.spawner = nil
    self.ui = nil

    self.mainMenu = nil

    self.gameOver = nil

    self.shopMenu = nil

    self.hasSaveData = false
    
    self:setupMainMenu()
end

function GameManager:createSaveGameData()
    return {
        curLevel = self.curLevel,
        cities = self.cities,
        maxMissiles = self.maxMissiles,
        targetSpeed = self.targetSpeed,
        spawnRate = self.spawnRate,
        missileSpeed = self.missileSpeed,
        score = self.score,
        scraps = self.scraps,
        highScore = self.highScore
    }
end

function GameManager:loadGameDataCities()
    for i=1, #self.cities, 1 do
        self.cities[i] = createGameDataCity(self.cities[i])
    end
end

function GameManager:loadSaveGameData(gameData)
    if not gameData then
        return
    end
    
    self.curLevel = gameData.curLevel
    
    if gameData.cities then
        self.cities = gameData.cities
        self:loadGameDataCities()
    end
    
    self.maxMissiles = gameData.maxMissiles
    self.targetSpeed = gameData.targetSpeed
    self.spawnRate = gameData.spawnRate
    self.missileSpeed = gameData.missileSpeed
    self.score = gameData.score
    self.scraps = gameData.scraps
    self.highScore = gameData.highScore

    self.hasSaveData = true

    self.mainMenu:foundGameData()
end

function GameManager:clearData()
    self.score = 0
    self.scraps = 0
    self.curLevel = 1
    self.state = gameStates.MAIN_MENU
    self.cities = nil
    self.spawnRate = startSpawnRate
    self.targetSpeed = startTargetSpeed
    self.maxMissiles = startMaxMissiles
    self.missileSpeed = startMissileSpeed
end

function GameManager:doesHaveSaveData()
    return self.hasSaveData
end

function GameManager:setupMainMenu()
    self:deactivateLevel()
    self:deactivateGameOver()
    self:deactivateShopMenu()
    gfx.clear()
    -- TODO: deactivate shop menu
    self.state = gameStates.MAIN_MENU
    self.mainMenu = MainMenu(self)
end

function GameManager:deactivateMainMenu()
    if self.mainMenu then
        self.mainMenu:remove()
    end
end

function GameManager:setupShopMenu()
    self:deactivateLevel()
    self:deactivateGameOver()
    self:deactivateMainMenu()
    gfx.clear()
    -- TODO: deactivate shop menu
    self.state = gameStates.SHOP_MENU
    self.shopMenu = ShopMenu(self)
end

function GameManager:deactivateShopMenu()
    if self.shopMenu then
        self.shopMenu:remove()
    end
end

function GameManager:setupGameOver()
    self:deactivateLevel()
    self:deactivateMainMenu()
    self:deactivateShopMenu()
    gfx.clear()
    self.state = gameStates.GAME_OVER
    self.gameOver = GameOver(self)
end

function GameManager:deactivateGameOver()
    if self.gameOver then
        self.gameOver:remove()
    end
end

function GameManager:setupLevel()
    self:deactivateMainMenu()
    self:deactivateGameOver()
    self:deactivateShopMenu()
    gfx.clear()
    -- TODO: deactivate shop menu
    
    self.state = gameStates.LEVEL
    self.levelManager = Level(self, self.curLevel, self.cities)
    self.target = Target(self, self.targetSpeed, self.maxMissiles)
    self.spawner = EnemySpawner(self.spawnRate)
    self.spawner:startSpawner()
    self.ui = UIOverlay(self, self.target)
end

function GameManager:deactivateLevel()
    self.state = gameStates.SHOP_MENU
    
    if self.levelManager then
        self.levelManager:remove()
        self.levelManager = nil
    end
    
    if self.target then
        self.target:removeMissiles()
        self.target:remove()
        self.target = nil
    end
    
    if self.spawner then
        self.spawner:stopSpawner()
        self.spawner = nil
    end
    
    if self.ui then
        self.ui:remove()
        self.ui = nil
    end
end

function GameManager:stopAllSpawners()
    if self.spawner then
        self.spawner:stopSpawner()
    end
end

function GameManager:areThereEnemies()
    if self.spawner and self.spawner:areThereEnemies() then
        return true
    end
    
    return false
end

function GameManager:clearStats()
    self.gameOverScore = self.score
    self.gameOverScraps = self.scraps
    self.gameOverLevel = self.curLevel

    self.highScore = math.max(self.highScore, self.score)

    self.score = 0
    self.scraps = 0
    self.curLevel = 1
    self.cities = nil
    self.spawnRate = startSpawnRate
    self.targetSpeed = startTargetSpeed
    self.maxMissiles = startMaxMissiles
    self.missileSpeed = startMissileSpeed
end

function GameManager:levelSuccess()
    self.curLevel += 1
    self.spawnRate = math.max(math.floor(0.9 * self.spawnRate), 1000)
    self:setupShopMenu()
end

function GameManager:levelFailure()
    self:clearStats()
    self:setupGameOver()
end

function GameManager:addScraps(numScraps)
    self.scraps += numScraps
end

function GameManager:removeScraps(numScraps)
    if numScraps > self.scraps then
        return false
    end
    
    self.scraps -= numScraps
    
    return true
end

function GameManager:getScraps(numScraps)
    return self.scraps
end

function GameManager:getScore()
    return self.score
end

function GameManager:addScore(numScore)
    self.score += numScore
end

function GameManager:getLevel()
    return self.curLevel
end

function GameManager:setCities(cities)
    self.cities = cities
end

function GameManager:getMaxMissiles()
    return self.maxMissiles
end

function GameManager:upgradeMaxMissiles(addMissiles)
    self.maxMissiles += addMissiles
end

function GameManager:getMissileSpeed()
    return self.missileSpeed
end

function GameManager:upgradeMissileSpeed(addSpeed)
    self.missileSpeed += addSpeed
end

function GameManager:getTargetSpeed()
    return self.targetSpeed
end

function GameManager:upgradeTargetSpeed(addSpeed)
    self.targetSpeed += addSpeed
end

function GameManager:getGameOverStats()
    return self.gameOverScore, self.gameOverScraps, self.gameOverLevel
end

function GameManager:update()
    if self.state == gameStates.MAIN_MENU then
        self.mainMenu:update()
    elseif self.state == gameStates.SHOP_MENU then
        self.shopMenu:update()
    elseif self.state == gameStates.LEVEL then
        self.ui:update()
        self.levelManager:update()
    elseif self.state == gameStates.GAME_OVER then
        self.gameOver:update()
    end

    playdate.drawFPS(0, 80)
end
