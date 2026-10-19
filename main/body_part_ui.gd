extends TextureRect
class_name BodyPartUI

var id: int
var type: BodyPart.Type

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

func _on_mouse_entered() -> void:
	Global.shake_control(self)
	self_modulate = Color(2.0, 2.0, 2.0, 1.0)

func _on_mouse_exited() -> void:
	#if Global.game_state != Global.GameState.GAMEPLAY_XRAY:
	self_modulate = Color.WHITE
