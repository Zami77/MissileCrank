local gfx <const> = playdate.graphics

class('City').extends(gfx.sprite)

local cityStates = {
	ACTIVE = 0,
	DESTROYED = 1
}

local cityMap = {
	"city-1"
}

function City:init(xOrigin)
	self.state = cityStates.ACTIVE
	local randCity = math.random(#cityMap)
	local cityImage = gfx.image.new("images/cities/" .. cityMap[randCity])
	self:setImage(cityImage)
	local sprX, sprY = self:getSize()
	self:setCollideRect(0, 0, sprX, sprY)
	self:setGroups(CityGroup)
	self:moveTo(xOrigin, screenHeight - sprY // 2)
	self:setZIndex(cityZIndex)
	self:add()
end

function City:destroy()
	local cityDestroyedImage = gfx.image.new("images/cities/city-destroyed")
	self:setImage(cityDestroyedImage)
	self.state = cityStates.DESTROYED

	audioManager:playCityExplosion()
end

function City:isActive()
	return self.state == cityStates.ACTIVE
end
