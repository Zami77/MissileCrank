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
	
	self.startLevelTimer = pd.timer.new(secondsToMs(3))
end


function UIOverlay:update()
	gfx.pushContext()
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		gfx.drawTextInRect("Missiles: " .. self.targetRef.curMissiles .. "/" .. self.targetRef.maxMissiles, screenWidth - 100, 0, 100, 100)
		gfx.drawTextInRect("Score: " .. self.gameManager:getScore(), 0, 0, 100, 100)
		
		if self.startLevelTimer.timeLeft > 0 then
			gfx.drawTextInRect("Level " .. self.gameManager:getLevel(), screenWidth / 2 - 20, screenHeight / 2, 100, 100)
		end
	gfx.popContext()
end

