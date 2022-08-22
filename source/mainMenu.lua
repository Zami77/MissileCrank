local pd <const> = playdate
local gfx <const> = playdate.graphics

local menuOptions = {
	"Start Game",
	"Instructions"
}
local gridview = pd.ui.gridview.new(0, 32)
local gridviewSprite = gfx.sprite.new()


class('MainMenu').extends(gfx.sprite)

function MainMenu:init()
	--self.super.init(self)
	
	gridview:setNumberOfRows(#menuOptions)
	gridview:setCellPadding(2, 2, 2, 2)
	
	gridview.backgroundImage = gfx.nineSlice.new("images/ui/main-menu-border", 7, 7, 18, 18)
	gridview:setContentInset(5, 5, 5, 5)
	
	gridviewSprite:setCenter(0, 0)
	gridviewSprite:moveTo(100, 70)
	gridviewSprite:add()
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
	gfx.pushContext()
		if selected then
			gfx.fillRoundRect(x, y, width, height, 4)
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		else
			gfx.setImageDrawMode(gfx.kDrawModeCopy)
		end
		
		local fontHeight = gfx.getSystemFont():getHeight()
		gfx.drawTextInRect(menuOptions[row], x, y + (height // 2 - fontHeight // 2), width, height, nil, nil, kTextAlignment.center)
	gfx.popContext()
end

function MainMenu:update()
	if pd.buttonJustPressed(pd.kButtonUp) then
		gridview:selectPreviousRow(true)
	elseif pd.buttonJustPressed(pd.kButtonDown) then
		gridview:selectNextRow(true)
	end
	
	if gridview.needsDisplay then
		local gridviewImage = gfx.image.new(200, 100)
		gfx.pushContext(gridviewImage)
			gridview:drawInRect(0, 0, 200, 100)
		gfx.popContext()
		gridviewSprite:setImage(gridviewImage)
	end
end