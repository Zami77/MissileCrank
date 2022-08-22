local gfx <const> = playdate.graphics
local spawnStates = {
	RUNNING = 0,
	STOPPED = 1
}

class('EnemySpawner').extends()

function EnemySpawner:init(spawnRate, enemyType)
	spawnRate = spawnRate or 5
	enemyType = enemyType or EnemyTypes.ENEMY_BASIC
	self.state = spawnStates.RUNNING
	self.spawnRate = math.max(spawnRate, 1)
	self.enemyType = enemyType
	EnemySpawner.super.init(self)
end

function EnemySpawner:createSpawnTimer()
	if self.state == spawnStates.STOPPED then
		return
	end
	
	createEnemy(self.enemyType)

	local randSpawnRate = math.random(self.spawnRate - 1, self.spawnRate)
	
	playdate.timer.performAfterDelay(secondsToMs(randSpawnRate), function()
		self:createSpawnTimer()
	end)
end

function EnemySpawner:startSpawner()
	self.state = spawnStates.RUNNING
	self:createSpawnTimer()
end

function EnemySpawner:stopSpawner()
	self.state = spawnStates.STOPPED
end

function EnemySpawner:updateSpawnRate(newRate)
	self.spawnRate = newRate
end
