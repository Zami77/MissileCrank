local snd <const> = playdate.sound
local normalVolume = 0.1
local shortBurst = 0.1
local mediumBurst = 0.2

class('AudioManager').extends()

function AudioManager:init()
	self.missileSynth = snd.synth.new(snd.kWaveSawtooth)
	self.explosionSynth = snd.synth.new(snd.kWaveNoise)
	self.menuSynth = snd.synth.new(snd.kWaveSine)
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
	self.menuSynth:playNote('C4', normalVolume, shortBurst)
end

function AudioManager:playMenuDown()
	self.menuSynth:playNote('G3', normalVolume, shortBurst)
end

function AudioManager:playConfirmation()
	self.menuSynth:playNote('C5', normalVolume, shortBurst)
end

function AudioManager:playError()
	self.explosionSynth:playNote('C1', normalVolume, shortBurst)
end