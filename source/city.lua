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

function createGameDataCity(gameDataCity)
	local newCity = City(gameDataCity.x)
	newCity.state = gameDataCity.state
	
	if newCity.state == cityStates.DESTROYED then
		local cityDestroyedImage = gfx.image.new("images/cities/city-destroyed")
		newCity:setImage(cityDestroyedImage)
	end
	
	return newCity
end