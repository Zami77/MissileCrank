local gfx <const> = playdate.graphics
local pd <const> = playdate

class('GameOver').extends(gfx.sprite)

function GameOver:setBackground()
    local backgroundImage = nil
    backgroundImage = gfx.image.new("images/backgrounds/DefaultBackgroundWhite")
    assert(backgroundImage)
    
    gfx.sprite.setBackgroundDrawingCallback(
        function (x, y, width, height)
            backgroundImage:draw(0, 0)
        end
    )
end

function GameOver:init(gameManager)
	assert(gameManager)
	
	GameOver.super.init(self)
	
	self.gameManager = gameManager
    self.textBoxWidth = 250
    self.textBoxHeight = gfx.getSystemFont():getHeight()
	self:setZIndex(uiZindex)
	self:moveTo(0, 0)
	self:add()
    
    self:setBackground()

    self.gameOverScore, self.gameOverScraps, self.gameOverLevel = self.gameManager:getGameOverStats()
end


function GameOver:update()
	gfx.pushContext()
		gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
        gfx.drawTextInRect("Score: " .. self.gameOverScore, screenWidth // 2 - self.textBoxWidth // 2, screenHeight // 2 - self.textBoxHeight // 2, self.textBoxWidth, self.textBoxHeight, nil, nil, kTextAlignment.center)
        gfx.drawTextInRect("Scraps: " .. self.gameOverScraps, screenWidth // 2 - self.textBoxWidth // 2, screenHeight // 2 + self.textBoxHeight // 2, self.textBoxWidth, self.textBoxHeight, nil, nil, kTextAlignment.center)


        gfx.drawTextInRect("Press B to go to Main Menu...", screenWidth // 2 - self.textBoxWidth // 2, screenHeight - self.textBoxHeight, self.textBoxWidth, self.textBoxHeight, nil, nil, kTextAlignment.center)
	gfx.popContext()

    if pd.buttonJustPressed(pd.kButtonB) then
        self.gameManager:setupMainMenu()
    end
end

