local gfx <const> = playdate.graphics

class('UIOverlay').extends(gfx.sprite)

function UIOverlay:init()
	UIOverlay.super.init(self)
	self:setZIndex(uiZindex)
	self:moveTo(0, 0)
	self:add()
end

function UIOverlay:draw()
	gfx.drawTextInRect("Template", screenWidth // 2, screenHeight - 20, 100, 100)
end

function UIOverlay:update()
	self:markDirty()
end

