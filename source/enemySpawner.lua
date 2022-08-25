local gfx <const> = playdate.graphics
local spawnStates = {
	RUNNING = 0,
	STOPPED = 1
}

local enemyTypes = {
	ENEMY_BASIC
}

class('EnemySpawner').extends()

function EnemySpawner:init(spawnRate, enemyType)
	spawnRate = spawnRate or 5
	enemyType = enemyType or enemyTypes.ENEMY_BASIC
	self.state = spawnStates.RUNNING
	self.spawnRate = math.max(spawnRate, 1000)
	self.enemyType = enemyType
	self.enemies = {}
	EnemySpawner.super.init(self)
end

local function createEnemy(enemyType)
	if enemyType == enemyTypes.BasicEnemy then
		return EnemyBasic()
	end
end

function EnemySpawner:createSpawnTimer()
	if self.state == spawnStates.STOPPED then
		return
	end
	
	local randSpawnRate = math.random(self.spawnRate, self.spawnRate + 1000)
	
	playdate.timer.performAfterDelay(randSpawnRate, function()
		if self.state == spawnStates.RUNNING then
			self.enemies[#self.enemies + 1] = createEnemy(self.enemyType)
			self:createSpawnTimer()
		end
	end)
	
end

function EnemySpawner:startSpawner()
	self.state = spawnStates.RUNNING
	self:createSpawnTimer()
end

function EnemySpawner:stopSpawner()
	self.state = spawnStates.STOPPED
end

function EnemySpawner:areThereEnemies()
	for i=1, #self.enemies, 1 do
		if self.enemies[i] and self.enemies[i]:isAlive() then
			return true
		end
	end

	return false
end

function EnemySpawner:removeEnemies()
	for i=1, #self.enemies, 1 do
		self.enemies[i]:remove()
		self.enemies[i] = nil
	end

	self.enemies = nil
end
