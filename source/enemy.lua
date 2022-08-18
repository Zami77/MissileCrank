local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry
local enemyStates = {
	MOVING = 0,
	EXPLODING = 1
}

local function getStartAndGoalVectors()
	local startVec = geometry.vector2D.new(math.random(screenWidth), 0)
	local goalVec = geometry.vector2D.new(math.random(screenWidth), screenHeight - 20)
	return startVec, goalVec
end

class('Enemy').extends(gfx.sprite)

function Enemy:init(enemyImage)
	assert(enemyImage)
	Enemy.super.init(self)
	
	self:setImage(enemyImage)
	self:setCollideRect(0, 0, self:getSize())
	self:setGroups(EnemyGroup)
	self:setCollidesWithGroups({CityGroup, MissileGroup})
	
	local startVec, goalVec = getStartAndGoalVectors()
	self:moveTo(startVec.dx, startVec.dy)
	
	self.speed = 5
	self.goal = goalVec
	self.state = enemyStates.MOVING
	self:add()
end

function Enemy:explosion()
	self.state = enemyStates.EXPLODING
end

function Enemy:update()
	if self.state == enemyStates.MOVING then
		self:moveWithCollisions(self.goal.dx + self.speed, self.goal.dy + self.speed)
		
		local posVector = geometry.vector2D.new(self.x, self.y)
		
		if inVicinityOf(posVector, self.goal) then
			self:explosion()
		end
	elseif self.state == enemyStates.EXPLODING then
		self:remove()
	end
end