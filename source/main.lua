import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"

import "globals"
import "enemySpawner"
import "level"
import "background"
import "gameManager"
import "target"
import "missile"
import "city"
import "helper"
import "enemy"
import "enemyBasic"
import "uiOverlay"

local gfx <const> = playdate.graphics

local gameManager = nil

function init()
    math.randomseed(playdate.getSecondsSinceEpoch())
    gameManager = GameManager()
end

init()

-- Main Game Loop
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    gameManager:update()
end