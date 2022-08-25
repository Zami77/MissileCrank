local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local enemyStates = {
	MOVING = 0,
	EXPLODING = 1
}

local function getStartAndGoalVectors()
	local startVec = geometry.vector2D.new(math.random(screenWidth), 0)
	local goalVec = geometry.vector2D.new(math.random(screenWidth), screenHeight - 15)
	return startVec, goalVec
end

class('Enemy').extends(gfx.sprite)

function Enemy:init(enemyImage, pointsVal, scrapsVal)
	pointsVal = pointsVal or 10
	scrapsVal = scrapsVal or 1
	assert(enemyImage)
	Enemy.super.init(self)
	
	self:setImage(enemyImage)
	self:setCollideRect(0, 0, self:getSize())
	self:setGroups(EnemyGroup)
	self:setCollidesWithGroups({CityGroup, MissileGroup})
	self:setZIndex(enemyZIndex)
	
	local startVec, goalVec = getStartAndGoalVectors()
	self:moveTo(startVec.dx, startVec.dy)
	
	local enemyDir = goalVec - startVec
	enemyDir:normalize()
	
	self.speed = 1
	self.goal = goalVec
	self.state = enemyStates.MOVING
	self.enemyDir = enemyDir
	self.pointsVal = pointsVal
	self.scrapsVal = scrapsVal
	self:add()
end

function Enemy:isAlive()
	return self.state == enemyStates.MOVING
end

function Enemy:getPoints()
	return self.pointsVal
end

function Enemy:getScraps()
	return self.scrapsVal
end

function Enemy:explosion()
	if self.state == enemyStates.EXPLODING then
		return
	end
	
	self.explosionSheet = gfx.imagetable.new("images/enemies/enemy-explosion")
	assert(self.explosionSheet)
	self.explosionAnimation = gfx.animation.loop.new(100, self.explosionSheet, false)
	self:setImage(self.explosionSheet:getImage(self.explosionAnimation.frame))
	self:setCollideRect(0, 0, self:getSize())
	audioManager:playEnemyExplosion()
	self.state = enemyStates.EXPLODING
end

function Enemy:handleCollisions()
	local actualX, actualY, collisions = self:checkCollisions(self.x, self.y)
	
	if collisions then
		for index, collision in ipairs(collisions) do
			collidedObj = collision['other']
			--if collidedObj:isa(Enemy) and self:alphaCollision(collidedObj) then
			--	collidedObj:explosion()
			--end
			if collidedObj:isa(City) and collidedObj:isActive() and self:alphaCollision(collidedObj) then
				collidedObj:destroy()
			end
		end
	end
end

function Enemy:update()
	if self.state == enemyStates.MOVING then
		self:moveBy(self.enemyDir.dx * self.speed, self.enemyDir.dy * self.speed)
		
		local posVector = geometry.vector2D.new(self.x, self.y)
		
		if inVicinityOf(posVector, self.goal) then
			self:explosion()
		end
	elseif self.state == enemyStates.EXPLODING then
		if not self.explosionAnimation:isValid() then
			self:remove()
			return
		end
		
		self.explosionAnimation:draw(self.x, self.y)
		self:setImage(self.explosionSheet:getImage(self.explosionAnimation.frame))
		
		self:handleCollisions()
	end
end