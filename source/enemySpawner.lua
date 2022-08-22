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
	self.spawnRate = math.max(spawnRate, 1000)
	self.enemyType = enemyType
	self.enemies = {}
	EnemySpawner.super.init(self)
end

function EnemySpawner:createSpawnTimer()
	if self.state == spawnStates.STOPPED then
		return
	end
	
	self.enemies[#self.enemies + 1] = createEnemy(self.enemyType)

	local randSpawnRate = math.random(self.spawnRate - 1000, self.spawnRate)
	
	playdate.timer.performAfterDelay(randSpawnRate, function()
		self:createSpawnTimer()
	end)
end

function EnemySpawner:startSpawner()
	self.state = spawnStates.RUNNING
	self:createSpawnTimer()
end

function EnemySpawner:stopSpawner()
	self.state = spawnStates.STOPPED
	for i=1, #self.enemies, 1 do
		self.enemies[i]:remove()
	end
end

function EnemySpawner:updateSpawnRate(newRate)
	self.spawnRate = newRate
end
