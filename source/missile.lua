local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local missileState = {
    MOVING = 0,
    EXPLODING = 1
}

class('Missile').extends(gfx.sprite)

function Missile:init(originVector, goalVector, speed)
    Missile.super.init(self)
    
    speed = speed or 5

    -- Create missile
    local missileSize = 4
    local missileImage = gfx.image.new(missileSize * 2, missileSize * 2)
    gfx.pushContext(missileImage)
    gfx.drawCircleAtPoint(missileSize, missileSize, missileSize)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(missileSize - 1, missileSize - 1, missileSize - 1)
    gfx.popContext()

    self:setImage(missileImage)
    self:setCollideRect(0, 0, self:getSize())

    -- Get missile direction by end point minus start point
    local missileDir =  goalVector - originVector
    missileDir:normalize()

    self.missileDir = missileDir
    self.speed = speed
    self.goal = goalVector

    -- start missile at Cannon location
    self:setZIndex(missileZIndex)
    self:moveTo(originVector.dx, originVector.dy)

    -- set up explosion animation image table
    self.explosionSheet = gfx.imagetable.new("images/missile/explosion")
    self.state = missileState.MOVING
    self.explosionAnimation = nil
    assert(self.explosionSheet)
    
    self:add()
end

function Missile:explosion()
    self.explosionAnimation = gfx.animation.loop.new(100, self.explosionSheet, false)
    self.state = missileState.EXPLODING
end

function Missile:update()
    if self.state == missileState.EXPLODING then
        if not self.explosionAnimation:isValid() then
            self:remove()
            return
        end
        self.explosionAnimation:draw(self.goal.dx, self.goal.dy)
        self:setImage(self.explosionSheet:getImage(self.explosionAnimation.frame))
    elseif self.state == missileState.MOVING then
        local posVector = geometry.vector2D.new(self.x, self.y)

        if inVicinityOf(posVector, self.goal) then
            self:explosion()
            return
        end
        self:moveBy(self.missileDir.dx * self.speed, self.missileDir.dy * self.speed)
    end
end