class('GameManager').extends()

local gfx <const> = playdate.graphics
local backgroundManager = nil
local levelManager = nil
local target = nil
local spawner = nil
local ui = nil


function GameManager:init()
    GameManager.super.init(self)
    
    self.score = 0
    self.scraps = 0
    
    self.levelManager = Level()
    self.target = Target(self)
    self.spawner = EnemySpawner()
    self.spawner:startSpawner()
    
    self.ui = UIOverlay(self, self.target)
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
    self.ui:update()
end
