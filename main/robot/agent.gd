extends Robot
class_name Agent

func generate(): return

func _ready() -> void:
	voice_pitch = -5.0
	main_color = color_palette.pick_random()
	Global.game_scene.music_player.stop()
	#Global.game_scene.music_player_2.stream = load("res://main/assets/sounds/Agent B.mp3")
	Global.game_scene.music_player_2.play()

func say() -> void:
	Global.text_queue = comes_phrases
	#for text in comes_phrases:
	#	Global.current_text.append(text)

func _exit_tree() -> void:
	AudioManager.play_sound("res://main/assets/sounds/box_open.wav", Vector2(-10.0, 10.0))
	Global.move_to(Global.game_scene.panic_button, Vector2(1550, Global.game_scene.panic_button.position.y), 1.0)
	Global.game_scene.music_player.play()
	Global.game_scene.music_player_2.stop()
