local gfx <const> = playdate.graphics
local spawnStates = {
	RUNNING = 0,
	STOPPED = 1
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
	if enemyType == enemyTypes.ENEMY_BASIC then
		return EnemyBasic()
	elseif enemyType == enemyTypes.ENEMY_FAST then
		return EnemyFast()
	end
end

function EnemySpawner:createSpawnTimer()
	if self.state == spawnStates.STOPPED then
		return
	end
	
	local randSpawnRate = math.random(self.spawnRate - 1000, self.spawnRate)
	
	playdate.timer.performAfterDelay(randSpawnRate, function()
		self.enemies[#self.enemies + 1] = createEnemy(self.enemyType)
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
	end
end
