local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local btnPressed <const> = playdate.buttonIsPressed
local btnJustPressed <const> = playdate.buttonJustPressed
local defaultTargetSpeed = 3

class('Target').extends(gfx.sprite)

function Target:init(targetSpeed)
    self.targetSpeed = targetSpeed or defaultTargetSpeed
    Target.super.init(self)

    local targetImage = gfx.image.new("images/ui/TargetReticule")
    assert(targetImage)

    self:setImage(targetImage)
    self:moveTo(screenWidth // 2, screenHeight // 2)
    self:add()
end

function Target:update()
    local newX = 0
    local newY = 0
    local upperBoundX = screenWidth
    local lowerBoundX = 0
    local upperBoundY = screenHeight
    local lowerBoundY = 0

    if btnPressed(playdate.kButtonUp) and self.y > lowerBoundY then
        newY += -1
    end
    if btnPressed(playdate.kButtonDown) and self.y < upperBoundY then
        newY += 1
    end
    if btnPressed(playdate.kButtonLeft) and self.x > lowerBoundX then
        newX += -1
    end
    if btnPressed(playdate.kButtonRight) and self.x < upperBoundX then
        newX += 1
    end
    if btnJustPressed(playdate.kButtonA) then
        local originVector = geometry.vector2D.new(screenWidth // 2, screenHeight)
        local goalVector = geometry.vector2D.new(self.x, self.y)
        Missile(originVector, goalVector)
    end

    local normalizedVector = geometry.vector2D.new(newX, newY)
    normalizedVector:normalize()

    self:moveBy(normalizedVector.dx * self.targetSpeed, normalizedVector.dy * self.targetSpeed)
end