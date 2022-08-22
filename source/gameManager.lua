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
local startMaxMissiles = 5

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
    
    self:setupMainMenu()
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
    end
    
    if self.target then
        self.target:removeMissiles()
        self.target:remove()
    end
    
    if self.spawner then
        self.spawner:stopSpawner()
    end
    
    if self.ui then
        self.ui:remove()
    end
end

function GameManager:clearStats()
    self.gameOverScore = self.score
    self.gameOverScraps = self.scraps
    self.gameOverLevel = self.curLevel

    self.score = 0
    self.scraps = 0
    self.curLevel = 1
    self.cities = nil
    self.spawnRate = startSpawnRate
    self.targetSpeed = startTargetSpeed
    self.maxMissiles = startMaxMissiles
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
    elseif self.state == gameStates.GAME_OVER then
        self.gameOver:update()
    end

    playdate.drawFPS(0, 80)
end
