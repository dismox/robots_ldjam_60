extends TextureRect

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
			Global.game_scene.change_color(modulate)
			AudioManager.play_sound("res://main/assets/sounds/ralsei-splat.mp3", Vector2.ZERO, -10.0)
