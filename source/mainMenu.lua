local pd <const> = playdate
local gfx <const> = playdate.graphics
local startGame = "Start Game"
local instructions = "Instructions"
local continueGame = "Continue Game"
local menuOptions = {
	startGame,
	instructions,
	continueGame
}
local gridview = pd.ui.gridview.new(0, 32)
local gridviewSprite = gfx.sprite.new()


class('MainMenu').extends(gfx.sprite)

function MainMenu:setBackground()
    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/MainMenuBackground")
    assert(backgroundImage)
    
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
        end
    )
end

function MainMenu:init(gameManager)
	--self.super.init(self)
	self.gameManager = gameManager
	self.showInstructions = false
	
	gridview:setNumberOfRows(#menuOptions)
	gridview:setCellPadding(2, 2, 2, 2)
	
	gridview.backgroundImage = gfx.nineSlice.new("images/ui/main-menu-border", 7, 7, 18, 18)
	gridview:setContentInset(5, 5, 5, 5)
	
	gridviewSprite:setCenter(0, 0)
	gridviewSprite:moveTo(100, 70)
	gridviewSprite:add()

	
	
	self:setBackground()
end

function MainMenu:foundGameData()
	if self.gameManager:doesHaveSaveData() then
		menuOptions[#menuOptions+1] = continueGame
	end
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
	gfx.pushContext()
		local fontHeight = gfx.getSystemFont():getHeight()
		if selected then
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			gfx.fillRoundRect(x, y, width, height, 4)
			gfx.drawTextInRect('| ' .. menuOptions[row] .. ' |', x, y + (height // 2 - fontHeight // 2), width, height, nil, nil, kTextAlignment.center)
		else
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			gfx.drawTextInRect(menuOptions[row], x, y + (height // 2 - fontHeight // 2), width, height, nil, nil, kTextAlignment.center)
		end
		
	gfx.popContext()
end

function MainMenu:HandleMenuSelect()
	local section, row, col = gridview:getSelection()
	local selectedOption = menuOptions[row]
	
	if selectedOption == startGame then
		gridviewSprite:remove()
		self.gameManager:clearData()
		self.gameManager:setupLevel()
	elseif selectedOption == instructions then
		self.showInstructions = true
	elseif selectedOption == continueGame then
		gridviewSprite:remove()
		self.gameManager:setupShopMenu()
	end
end

function MainMenu:update()
	if gridview.needsDisplay then
		local gridviewImage = gfx.image.new(200, 100)
		gfx.pushContext(gridviewImage)
			gridview:drawInRect(0, 0, 200, 100)
		gfx.popContext()
		gridviewSprite:setImage(gridviewImage)
	end

	if self.showInstructions then
		local instructionText = 'Take charge and defend your home planet\'s cities!\n\nUse the crank to reload missiles.\n\nDestroying enemy ships will give you scraps. You can use scraps to get upgrades or convert to points.\n\nRounds will get progressively more challenging and Game Over will not occur until all of your cities have been destroyed.\n\nGood Luck!'
		gfx.pushContext()
			gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
			gfx.drawRect(0, 0, screenWidth, screenHeight)
			gfx.fillRect(0, 0, screenWidth, screenHeight)
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
			gfx.drawTextInRect(instructionText, 0, 0, screenWidth, screenHeight, nil, nil, kTextAlignment.center)
		gfx.popContext()

		if pd.buttonJustPressed(pd.kButtonB) then
			self.showInstructions = false
		elseif pd.buttonJustPressed(pd.kButtonA) then
			self.showInstructions = false
		end
	else
		if pd.buttonJustPressed(pd.kButtonUp) then
			audioManager:playMenuUp()
			gridview:selectPreviousRow(true)
		elseif pd.buttonJustPressed(pd.kButtonDown) then
			audioManager:playMenuDown()
			gridview:selectNextRow(true)
		elseif pd.buttonJustPressed(pd.kButtonA) then
			audioManager:playConfirmation()
			self:HandleMenuSelect()
		end
	end
end