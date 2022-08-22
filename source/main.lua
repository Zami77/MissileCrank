import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

import "globals"
import "enemySpawner"
import "level"
import "gameManager"
import "target"
import "missile"
import "city"
import "helper"
import "enemy"
import "enemyBasic"
import "uiOverlay"
import "mainMenu"
import "gameOver"
import "shopMenu"

local gfx <const> = playdate.graphics

local gameManager = nil

function init()
    math.randomseed(playdate.getSecondsSinceEpoch())
    gameManager = GameManager()
    -- Adjust this value for screen shutter
    playdate.setGCScaling(0, 1.0)
end

init()

-- Main Game Loop
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    gameManager:update()
end