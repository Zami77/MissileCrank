local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local enemyStates = {
	MOVING = 0,
	EXPLODING = 1
}

local function getStartAndGoalVectors(goalPos)
	local startVec = geometry.vector2D.new(math.random(400), 0)
	local goalBuffer = 40
	local goalVec = nil
	if goalPos then
		goalVec = geometry.vector2D.new(math.random(goalPos.x - goalBuffer, goalPos.x + goalBuffer), 240 - 15)
	else
		goalVec = geometry.vector2D.new(math.random(400), 240 - 15)
	end
	return startVec, goalVec
end

local function getCityPos(cities)
	if not cities then
		return nil
	end
	activeCities = {}

	for i=1, #cities, 1 do
		if cities[i]:isActive() then
			activeCities[#activeCities+1] = geometry.vector2D.new(cities[i].x, cities[i].y)
		end
	end

	return activeCities[math.random(#activeCities)]
end

class('Enemy').extends(gfx.sprite)

function Enemy:init(enemyImage, pointsVal, scrapsVal, speed, cities, audioManager)
	pointsVal = pointsVal or 10
	scrapsVal = scrapsVal or 1
	assert(enemyImage)
	Enemy.super.init(self)
	
	self:setImage(enemyImage)
	self:setCollideRect(0, 0, self:getSize())
	self:setGroups(EnemyGroup)
	self:setCollidesWithGroups({CityGroup, MissileGroup})
	self:setZIndex(enemyZIndex)
	
	self.cities = cities
	
	local startVec, goalVec = getStartAndGoalVectors(getCityPos(cities))
	self:moveTo(startVec.dx, startVec.dy)
	
	local enemyDir = goalVec - startVec
	enemyDir:normalize()

	self.speed = speed or 1
	self.goal = goalVec
	self.state = enemyStates.MOVING
	self.enemyDir = enemyDir
	self.pointsVal = pointsVal
	self.scrapsVal = scrapsVal
	self.audioManager = audioManager or AudioManager()

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
	self.audioManager:playEnemyExplosion()
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
				self.audioManager:playCityExplosion()
				collidedObj:destroy()
			end
		end
	end
end

function Enemy:update()
	if self.state == enemyStates.MOVING then
		self:moveBy(self.enemyDir.dx * self.speed, self.enemyDir.dy * self.speed)
		
		if self.y >= self.goal.dy then
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