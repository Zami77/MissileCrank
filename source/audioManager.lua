local snd <const> = playdate.sound
local normalVolume = 0.5
local shortBurst = 0.1
local mediumBurst = 0.2

class('AudioManager').extends()

function AudioManager:init()
	self.missileSynth = snd.synth.new(snd.kWaveSawtooth)
	self.explosionSynth = snd.synth.new(snd.kWaveNoise)
	self.menuSynth = snd.synth.new(snd.kWaveSine)

	self.battleThemeSong = snd.fileplayer.new('sounds/Battle Theme 1')
	self.mainMenuThemeSong = snd.fileplayer.new('sounds/Main Menu Theme')
	self.shopMenuThemeSong = snd.fileplayer.new('sounds/Shop Theme')
end

function AudioManager:playMissileLaunch()
	self.missileSynth:playNote('C2', normalVolume, shortBurst)
end

function AudioManager:playExplosion()
	self.explosionSynth:playNote('C0', normalVolume, shortBurst)
end

function AudioManager:playEnemyExplosion()
	self.explosionSynth:playNote('C#0', normalVolume, shortBurst)
end

function AudioManager:playCityExplosion()
	self.explosionSynth:playNote('A0', normalVolume, mediumBurst)
end

function AudioManager:playMenuUp()
	self.menuSynth:playNote('A3', normalVolume, shortBurst)
end

function AudioManager:playMenuDown()
	self.menuSynth:playNote('G3', normalVolume, shortBurst)
end

function AudioManager:playConfirmation()
	self.menuSynth:playNote('B4', normalVolume, shortBurst)
end

function AudioManager:playError()
	self.explosionSynth:playNote('C1', normalVolume, shortBurst)
end

function AudioManager:playBattleThemeSong()
	self.battleThemeSong:play(0)
end

function AudioManager:stopBattleThemeSong()
	self.battleThemeSong:stop()
end

function AudioManager:playMainMenuThemeSong()
	self.mainMenuThemeSong:play(0)
end

function AudioManager:stopMainMenuThemeSong()
	self.mainMenuThemeSong:stop()
end

function AudioManager:playShopMenuThemeSong()
	self.shopMenuThemeSong:play(0)
end

function AudioManager:stopShopMenuThemeSong()
	self.shopMenuThemeSong:stop()
end