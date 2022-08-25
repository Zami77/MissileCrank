local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local btnPressed <const> = playdate.buttonIsPressed
local btnJustPressed <const> = playdate.buttonJustPressed

class('Target').extends(gfx.sprite)

function Target:init(gameManager, targetSpeed, maxMissiles)
    assert(gameManager)
    self.targetSpeed = targetSpeed or 3
    self.maxMissiles = maxMissiles or 5
    self.curMissiles = self.maxMissiles
    self.gameManager = gameManager
    self.missilesFired = {}
    
    Target.super.init(self)

    local targetImage = gfx.image.new("images/ui/TargetReticule")
    assert(targetImage)

    self:setImage(targetImage)
    self:moveTo(400 // 2, 240 // 2)
    self:setZIndex(targetZIndex)
    self:add()
end

function Target:removeMissiles()
    for i=1, #self.missilesFired, 1 do
        self.missilesFired[i]:remove()
        self.missilesFired[i] = nil
    end
    
    self.missilesFired = nil
end

function Target:handleMovement()
    local deltaX = 0
    local deltaY = 0
    
    if btnPressed(playdate.kButtonUp) and self.y > 0 then
        deltaY += -1
    end
    if btnPressed(playdate.kButtonDown) and self.y < 240 then
        deltaY += 1
    end
    if btnPressed(playdate.kButtonLeft) and self.x > 0 then
        deltaX += -1
    end
    if btnPressed(playdate.kButtonRight) and self.x < 400 then
        deltaX += 1
    end
    
    local normalizedVector = geometry.vector2D.new(deltaX, deltaY)
    normalizedVector:normalize()
    
    self:moveBy(normalizedVector.dx * self.targetSpeed, normalizedVector.dy * self.targetSpeed)
end

function Target:handleFire()
    if btnJustPressed(playdate.kButtonA) and self.curMissiles > 0 then
        local originVector = geometry.vector2D.new(400 // 2, 240)
        local goalVector = geometry.vector2D.new(self.x, self.y)
        self.missilesFired[#self.missilesFired+1] =  Missile(originVector, goalVector, self.gameManager)
        self.curMissiles -= 1
    end
end

function Target:reload()
    self.curMissiles = math.min(self.curMissiles + 1, self.maxMissiles)
end

function Target:handleReload()
    local crankTicks = playdate.getCrankTicks(1)
    if crankTicks == 1 then
        self:reload()
    end
end

function Target:update()
    self:handleMovement()
    self:handleFire()
    self:handleReload()
end