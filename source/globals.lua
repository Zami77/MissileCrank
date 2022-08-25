screenWidth = 400
screenHeight = 240

levelZIndex = 0
cityZIndex = 1
enemyZIndex = 2
missileZIndex = 5
targetZIndex = 6
uiZindex = 7

EnemyGroup = 1
MissileGroup = 2
CityGroup = 3

-- Controls
FireButton = playdate.kButtonA
ConfirmationButton = playdate.kButtonA

enemyTypes = {
	ENEMY_BASIC = 0,
    ENEMY_FAST = 1
}

audioManager = AudioManager()