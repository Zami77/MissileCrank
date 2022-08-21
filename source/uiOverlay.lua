local gfx <const> = playdate.graphics

class('UIOverlay').extends(gfx.sprite)

function UIOverlay:init(targetRef)
	UIOverlay.super.init(self)
	self.targetRef = targetRef
	self:setZIndex(uiZindex)
	self:moveTo(0, 0)
	self:add()
end


function UIOverlay:update()
	gfx.pushContext()
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawTextInRect("Missiles: " .. self.targetRef.curMissiles .. "/" .. self.targetRef.maxMissiles, screenWidth - 100, 0, 100, 100)
	gfx.popContext()
end

