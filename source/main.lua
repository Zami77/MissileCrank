import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"

import "globals"
import "levelSprite"
import "backgroundSprite"
import "gameManager"
import "target"
import "missile"
import "helper"
import "enemy"
import "enemyBasic"
import "enemySpawner"

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
end