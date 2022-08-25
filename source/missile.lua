local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local missileState = {
    MOVING = 0,
    EXPLODING = 1
}

class('Missile').extends(gfx.sprite)

function Missile:init(originVector, goalVector, gameManager)
    assert(gameManager)
    Missile.super.init(self)
    
    local speed = gameManager:getMissileSpeed() or 4

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
    self:setGroups(MissileGroup)
    self:setCollidesWithGroups(EnemyGroup)

    -- Get missile direction by end point minus start point
    local missileDir =  goalVector - originVector
    missileDir:normalize()

    self.missileDir = missileDir
    self.speed = speed
    self.goal = goalVector
    self.gameManager = gameManager

    -- start missile at Cannon location
    self:setZIndex(missileZIndex)
    self:moveTo(originVector.dx, originVector.dy)

    -- set up explosion animation image table
    self.explosionSheet = gfx.imagetable.new("images/missile/explosion")
    self.state = missileState.MOVING
    self.explosionAnimation = nil
    assert(self.explosionSheet)
    
    self:add()
    
    audioManager:playMissileLaunch()
end

function Missile:explosion()
    self.explosionAnimation = gfx.animation.loop.new(100, self.explosionSheet, false)
    self:setImage(self.explosionSheet:getImage(self.explosionAnimation.frame))
    self:setCollideRect(0, 0, self:getSize())
    audioManager:playExplosion()
    self.state = missileState.EXPLODING
end

function Missile:handleCollisions()
    local actualX, actualY, collisions = self:checkCollisions(self.x, self.y)
    
    if collisions then
        for index, collision in ipairs(collisions) do
            collidedObj = collision['other']
            if collidedObj:isa(Enemy) and collidedObj:isAlive() and self:alphaCollision(collidedObj) then
                self.gameManager:addScore(collidedObj:getPoints())
                self.gameManager:addScraps(collidedObj:getScraps())
                collidedObj:explosion()
            end
        end
    end
end

function Missile:update()
    if self.state == missileState.EXPLODING then
        if not self.explosionAnimation:isValid() then
            self:remove()
            return
        end
        self.explosionAnimation:draw(self.goal.dx, self.goal.dy)
        self:setImage(self.explosionSheet:getImage(self.explosionAnimation.frame))
        
        self:handleCollisions()
        
    elseif self.state == missileState.MOVING then
        local posVector = geometry.vector2D.new(self.x, self.y)

        if inVicinityOf(posVector, self.goal) then
            self:explosion()
            return
        end
        self:moveBy(self.missileDir.dx * self.speed, self.missileDir.dy * self.speed)
    end
end