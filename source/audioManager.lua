local snd <const> = playdate.sound

class('AudioManager').extends()

function AudioManager:init()
	self.missileSynth = snd.synth.new(snd.kWaveSquare)
end

function AudioManager:playMissileLaunch()
	print("playMissileLaunch")
	print(self.missileSynth:playNote('C3',1,2))
end