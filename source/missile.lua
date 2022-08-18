local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

class('Missile').extends(gfx.sprite)

function Missile:init(originVector, goalVector, speed)
    speed = speed or 5

    local missileSize = 4
    local missileImage = gfx.image.new(missileSize * 2, missileSize * 2)
    gfx.pushContext(missileImage)
    gfx.drawCircleAtPoint(missileSize, missileSize, missileSize)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(missileSize - 1, missileSize - 1, missileSize - 1)
    gfx.popContext()

    self:setImage(missileImage)
    self:setCollideRect(0, 0, self:getSize())

    local missileDir =  goalVector - originVector
    missileDir:normalize()

    self.missileDir = missileDir
    self.speed = speed
    self.goal = goalVector

    self:setZIndex(missileZIndex)
    self:moveTo(originVector.dx, originVector.dy)
    self:add()
end

function Missile:update()
    local posVector = geometry.vector2D.new(self.x, self.y)

    if inVicinityOf(posVector, self.goal) then
        -- TODO: have missile explode
        self:remove()
    end

    self:moveBy(self.missileDir.dx * self.speed, self.missileDir.dy * self.speed)
end