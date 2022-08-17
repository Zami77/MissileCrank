import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

import "globals"
import "gameManager"
import "levelSprite"

local gfx <const> = playdate.graphics

gameManagerInit()

-- Main Game Loop
function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()
end