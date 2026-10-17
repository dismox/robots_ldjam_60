extends TextureRect
class_name Item

var title: String = "unknown"


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
			Global.game_scene.change_item(self)

func _on_mouse_entered() -> void:
	Global.shake_control(self)
