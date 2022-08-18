local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

class('EnemyBasic').extends(Enemy)


function EnemyBasic:init()
	local enemyImage = gfx.image.new("images/enemies/Enemy-01.png")
	assert(enemyImage)
	EnemyBasic.super.init(self, enemyImage)
end