extends TextureRect
class_name BodyPart

@export var current_color: Color = Color.WHITE
@export var prefered_color: Color = Color.WHITE
@export var prefered_body_part: int
@export var current_body_part: int

@export var rustiness: float = 0.0

var defects

func change_color(color: Color):
	self_modulate = color
	current_color = self_modulate
	
func change_body_part(texture_id: int):
	
