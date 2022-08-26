local pd <const> = playdate
local gfx <const> = playdate.graphics

local itemOptions = {}
local gridview = pd.ui.gridview.new(0, 32)
local gridviewSprite = gfx.sprite.new()

local shopKeeperSprite = gfx.sprite.new()

local maxMissileUpgrade = 12
local maxTargetSpeedUpgrade = 6
local maxMissileSpeedUpgrade = 8

local targetUpgrade = 'Target Speed++'
local missileUpgrade = 'Max Missiles++'
local missileSpeedUpgrade = 'Missile Speed++'
local convertScrap = 'Convert Scrap'
local exitShop = 'Exit Shop'

local baseTargetPrice = 10
local baseMissilePrice = 5
local baseMissileSpeedPrice = 5

class('ShopMenu').extends(gfx.sprite)

function ShopMenu:setBackground()
    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/ShopBackground")
    assert(backgroundImage)
    
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
        end
    )
end

function ShopMenu:fillItemOptions()
	itemOptions = {}

	itemOptions[#itemOptions+1] = exitShop

	itemOptions[#itemOptions+1] = convertScrap

	if self.gameManager:getTargetSpeed() < maxTargetSpeedUpgrade then
		itemOptions[#itemOptions+1] = targetUpgrade
	end

	if self.gameManager:getMaxMissiles() < maxMissileUpgrade then
		itemOptions[#itemOptions+1] = missileUpgrade
	end

	if self.gameManager:getMissileSpeed() < maxMissileSpeedUpgrade then
		itemOptions[#itemOptions+1] = missileSpeedUpgrade
	end
end

function ShopMenu:init(gameManager)
	self.gameManager = gameManager
	self.startTimer = pd.timer.new(500)
	self.popupTimer = pd.timer.new()
	self.popupText = 'Welcome to the Command Shop!'
	self:startPopupTimer()

	self:fillItemOptions()
	
	gridview:setNumberOfRows(#itemOptions)
	gridview:setCellPadding(2, 2, 2, 2)
	
	gridview.backgroundImage = gfx.nineSlice.new("images/ui/main-menu-border", 7, 7, 18, 18)
	gridview:setContentInset(5, 5, 5, 5)
	
	gridviewSprite:setCenter(0, 0)
	gridviewSprite:moveTo(100, screenHeight - 120)
	gridviewSprite:add()

	local shopKeeperImage = gfx.image.new("images/ui/ShopKeeper")
	shopKeeperSprite:setImage(shopKeeperImage)
	shopKeeperSprite:setZIndex(uiZindex)
	shopKeeperSprite:moveTo(screenWidth - 48, screenHeight // 2 - 25)
	shopKeeperSprite:add()
	
	self:setBackground()
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
	gfx.pushContext()
		local fontHeight = gfx.getSystemFont():getHeight()
		if selected then
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			gfx.fillRoundRect(x, y, width, height, 4)
			gfx.drawTextInRect('| ' .. itemOptions[row] .. ' |', x, y + (height // 2 - fontHeight // 2), width, height, nil, nil, kTextAlignment.center)
		else
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			gfx.drawTextInRect(itemOptions[row], x, y + (height // 2 - fontHeight // 2), width, height, nil, nil, kTextAlignment.center)
		end
		
	gfx.popContext()
end

function ShopMenu:startPopupTimer()
	self.popupTimer = pd.timer.new(3000)
end

function ShopMenu:getTargetUpgradePrice()
	return (self.gameManager:getTargetSpeed() + 1) * baseTargetPrice
end

function ShopMenu:getMissileUpgradePrice()
	return (self.gameManager:getMaxMissiles() + 1) * baseMissilePrice
end

function ShopMenu:getMissileSpeedUpgradePrice()
	return (self.gameManager:getMissileSpeed() + 1) * baseMissileSpeedPrice
end

function ShopMenu:getSelectedOption()
	local section, row, col = gridview:getSelection()
	return itemOptions[row]
end

function ShopMenu:HandleMenuSelect()
	local selectedOption = self:getSelectedOption()
	local success = false
	if selectedOption == exitShop then
		gridviewSprite:remove()
		self.gameManager:setupLevel()
		success = true
	elseif selectedOption == targetUpgrade then
		local tgtPrice = self:getTargetUpgradePrice()
		if self.gameManager:getScraps() >= tgtPrice then
			self.gameManager:removeScraps(tgtPrice)
			self.gameManager:upgradeTargetSpeed(1)
			self.popupText = "Upgraded Target Speed!"
			success = true
		else
			self.popupText = 'Not enough scraps'
		end
		self:startPopupTimer()
	elseif selectedOption == missileUpgrade then
		local missilePrice = self:getMissileUpgradePrice()
		if self.gameManager:getScraps() >= missilePrice then
			self.gameManager:removeScraps(missilePrice)
			self.gameManager:upgradeMaxMissiles(1)
			self.popupText = "Upgraded Max Missiles!"
			success = true
		else
			self.popupText = 'Not enough scraps'
		end
		self:startPopupTimer()
	elseif selectedOption == missileSpeedUpgrade then
		local missileSpeedPrice = self:getMissileSpeedUpgradePrice()
		if self.gameManager:getScraps() >= missileSpeedPrice then
			self.gameManager:removeScraps(missileSpeedPrice)
			self.gameManager:upgradeMissileSpeed(1)
			self.popupText = "Upgraded Missile Speed!"
			success = true
		else
			self.popupText = 'Not enough scraps'
		end
		self:startPopupTimer()
	elseif selectedOption == convertScrap then
		local totalScraps = self.gameManager:getScraps()
		self.gameManager:removeScraps(totalScraps)
		self.gameManager:addScore(totalScraps)
		self.popupText = "Converted " .. totalScraps .. " Scrap!"
		success = true
		self:startPopupTimer()
	end

	if success then
		audioManager:playConfirmation()
	else
		audioManager:playError()
	end
end

function ShopMenu:displayPrice()
	local selectedOption = self:getSelectedOption()
	local price = 0

	if selectedOption == targetUpgrade then
		price = self:getTargetUpgradePrice()
	elseif selectedOption == missileUpgrade then
		price = self:getMissileUpgradePrice()
	elseif selectedOption == missileSpeedUpgrade then
		price = self:getMissileSpeedUpgradePrice()
	end

	gfx.pushContext()
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		gfx.drawText("Price: " .. price, screenWidth - 75, 0)
		gfx.drawText("Scraps: " .. self.gameManager:getScraps(), 0, 0)
		gfx.drawText("Score: " .. self.gameManager:getScore(), 0, screenHeight - gfx.getSystemFont():getHeight())
		gfx.drawText("Level: " .. self.gameManager:getLevel(), screenWidth - 75, screenHeight - gfx.getSystemFont():getHeight())
	gfx.popContext()
end

function ShopMenu:displayPopup()
	local popupWidth = 400
	local popupHeight = gfx.getSystemFont():getHeight()
	gfx.pushContext()
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		gfx.drawTextInRect(self.popupText, screenWidth // 2 - popupWidth // 2, screenHeight // 3, popupWidth, popupHeight, nil, nil, kTextAlignment.center)
	gfx.popContext()
end

function ShopMenu:cleanup()
	shopKeeperSprite:remove()
end

function ShopMenu:update()
	if gridview.needsDisplay then
		local gridviewImage = gfx.image.new(200, 100)
		gfx.pushContext(gridviewImage)
		gridview:drawInRect(0, 0, 200, 100)
		gfx.popContext()
		gridviewSprite:setImage(gridviewImage)
	end
	
	self:displayPrice()

	if self.popupTimer.timeLeft > 0 then
		self:displayPopup()
	end

	-- To help prevent mashing confirmation accidentally
	if self.startTimer.timeLeft > 0 then
		return
	end

	if pd.buttonJustPressed(pd.kButtonUp) then
		audioManager:playMenuUp()
		gridview:selectPreviousRow(true)
	elseif pd.buttonJustPressed(pd.kButtonDown) then
		audioManager:playMenuDown()
		gridview:selectNextRow(true)
	elseif pd.buttonJustPressed(pd.kButtonA) then
		self:HandleMenuSelect()
	end
end