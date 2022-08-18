local gfx <const> = playdate.graphics
local spawnStates = {
	RUNNING = 0,
	STOPPED = 1
}
local state = spawnStates.STOPPED

local function createSpawnTimer()
	if state == spawnStates.STOPPED then
		return
	end
	
	local spawnRate = math.random(1000, 2000)
	
	playdate.timer.performAfterDelay(spawnRate, function()
		createSpawnTimer()
		EnemyBasic()
	end)
end

function enemySpawner()
	state = spawnStates.RUNNING
	createSpawnTimer()
end


function stopSpawner()
	state = spawnStates.STOPPED
end
