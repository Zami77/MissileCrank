class('GameManager').extends()

local gfx <const> = playdate.graphics

local gameStates = {
    MAIN_MENU = 0,
    SHOP_MENU = 1,
    LEVEL = 2
}
local backgroundManager = nil
local levelManager = nil
local target = nil
local spawner = nil
local ui = nil


function GameManager:init()
    GameManager.super.init(self)
    
    self.score = 0
    self.scraps = 0
    self.curLevel = 1
    self.state = gameStates.MAIN_MENU
    
    self.levelManager = nil
    self.target = nil
    self.spawner = nil
    self.ui = nil
    self.mainMenu = nil
    
    self:setupMainMenu()
end

function GameManager:setupMainMenu()
    self.mainMenu = MainMenu()
end

function GameManager:deactivateMainMenu()
    self.mainMenu:remove()
end

function GameManager:setupLevel()
    self.state = gameStates.LEVEL
    self.levelManager = Level(self.curLevel)
    self.target = Target(self)
    self.spawner = EnemySpawner()
    self.spawner:startSpawner()
    self.ui = UIOverlay(self, self.target)
end

function GameManager:deactivateLevel()
    self.state = gameStates.SHOP_MENU
    self.levelManager:remove()
    self.target:remove()
    self.spawner:stopSpawner()
    self.spawner:remove()
    self.ui:remove()
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

function GameManager:update()
    if self.state == gameStates.MAIN_MENU then
        self.mainMenu:update()
    elseif self.state == gameStates.SHOP_MENU then
    elseif self.state == gameStates.LEVEL then
        self.ui:update()
    end
end
