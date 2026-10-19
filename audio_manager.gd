extends Node

enum BusType {
	MASTER,
	MUSIC,
	SFX,
}

const BUS_TYPES = [
	"Master",
	"Music",
	"SFX",
]

func play_sound(sound, pitch_randomize: Vector2 = Vector2(0.0, 0.0), volume: float = 0.0):
	var player = AudioStreamPlayer.new()
	player.bus = BUS_TYPES[BusType.SFX]
	
	if sound is Array[AudioStream]:
		if sound.size() == 0:
			return
		player.stream = sound.pick_random()
	elif sound is String:
		player.stream = load(sound)
	else:
		player.stream = sound
		
	if pitch_randomize.x != 0.0 and pitch_randomize.y != 0.0:
		if pitch_randomize.y > pitch_randomize.x:
			var pitch_modulation = 1.0 + range(pitch_randomize.x, pitch_randomize.y).pick_random() / 100.0
			pitch_modulation = clamp(pitch_modulation, 0.1, 2.0)
			player.pitch_scale = pitch_modulation
		else:
			player.pitch_scale = 1.0 + pitch_randomize.x
		
	player.volume_db += volume
	
	add_child(player)
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
	return player
