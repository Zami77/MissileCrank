import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

import "globals"
import "levelSprite"
import "backgroundSprite"
import "gameManager"
import "target"
import "missile"
import "helper"

local gfx <const> = playdate.graphics

local gameManager = GameManager()

-- Main Game Loop
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end