extends TextureRect

func _process(_delta: float) -> void:
	position = get_global_mouse_position() - size/6
	
	
