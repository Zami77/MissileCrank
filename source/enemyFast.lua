local gfx <const> = playdate.graphics

class('EnemyFast').extends(Enemy)

function EnemyFast:init(cities)
	local enemyImage = gfx.image.new("images/enemies/Enemy-Fast.png")
	assert(enemyImage)
	local points = 20
	local scraps = 2
	local speed = 2
	EnemyFast.super.init(self, enemyImage, points, scraps, speed, cities)
end