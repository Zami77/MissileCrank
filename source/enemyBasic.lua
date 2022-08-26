local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

class('EnemyBasic').extends(Enemy)

function EnemyBasic:init(cities)
	local enemyImage = gfx.image.new("images/enemies/Enemy-01.png")
	assert(enemyImage)
	local points = 10
	local scraps = 1
	local speed = 1.2
	EnemyBasic.super.init(self, enemyImage, points, scraps, speed, cities)
end