local gfx <const> = playdate.graphics
local pd <const> = playdate

class('UIOverlay').extends(gfx.sprite)

function UIOverlay:init(gameManager, targetRef)
	assert(targetRef)
	assert(gameManager)
	
	UIOverlay.super.init(self)
	
	self.targetRef = targetRef
	self.gameManager = gameManager
	self:setZIndex(uiZindex)
	self:moveTo(0, 0)
	self:add()
	self.textBoxSize = 100
	self.startLevelTimer = pd.timer.new(secondsToMs(3))
end


function UIOverlay:update()
	gfx.pushContext()
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		gfx.drawTextInRect("Missiles: " .. self.targetRef.curMissiles .. "/" .. self.targetRef.maxMissiles, 400 - 100, 0, self.textBoxSize, self.textBoxSize)
		gfx.drawTextInRect("Score: " .. self.gameManager:getScore(), 0, 0, self.textBoxSize, self.textBoxSize)
		
		if self.startLevelTimer.timeLeft > 0 then
			gfx.drawTextInRect("Level " .. self.gameManager:getLevel(), 400 / 2 - 20, 240 / 2, self.textBoxSize, self.textBoxSize)
		end
	gfx.popContext()
end

