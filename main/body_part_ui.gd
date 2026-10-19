extends TextureRect
class_name BodyPartUI

var id: int
var type: BodyPartType.Type

@export var hover_noise: Array[AudioStream] = [
	load("res://main/assets/sounds/part_hover_1.wav"),
	load("res://main/assets/sounds/part_hover_2.wav"),
	load("res://main/assets/sounds/part_hover_3.wav"),
	load("res://main/assets/sounds/part_hover_4.wav"),
	load("res://main/assets/sounds/part_hover_5.wav"),
	load("res://main/assets/sounds/part_hover_6.wav"),
	load("res://main/assets/sounds/part_hover_7.wav"),
	load("res://main/assets/sounds/part_hover_8.wav"),
	load("res://main/assets/sounds/part_hover_9.wav"),
]

func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
			Global.game_scene.current_body_part_id = id
			Global.game_scene.current_body_part_type = type
			Global.game_scene.part_texture.texture = texture
			Global.game_scene.hide_parts_drawer()
			AudioManager.play_sound("res://main/assets/sounds/part_grab.wav", Vector2.ZERO, -5.0)

func _on_mouse_entered() -> void:
	Global.shake_control(self)
	AudioManager.play_sound(hover_noise, Vector2(0.0, 30.0), -10)
	self_modulate = Color(2.0, 2.0, 2.0, 1.0)

func _on_mouse_exited() -> void:
	#if Global.game_state != Global.GameState.GAMEPLAY_XRAY:
	AudioManager.play_sound(hover_noise, Vector2(-10.0, 0.0), -10)
	self_modulate = Color.WHITE
