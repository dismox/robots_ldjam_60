extends TextureRect
class_name BodyPart

@export var type: Type

@export var current_color: Color = Color.WHITE
@export var prefered_color: Color = Color.WHITE
@export var prefered_body_part: int
@export var current_body_part: int

@export var rustiness: float = 0.0

var defects

enum Type {
	HEAD,
	HEAD_TOP,
	NOSE,
	EYES,
	MOUTH,
	EARS,
	BODY_TOP,
	BODY_BOTTOM,
	ARM,
	SHOULDER,
	BRAIN,
	HEART,
	GUTS
}

func change_color(color: Color):
	self_modulate = color
	current_color = self_modulate
	
func change_body_part(type: Type, texture_id: int):
	return
	#texture = BodyPartsDatabase.get_body_part_texture(type, texture_id)
	current_body_part = texture_id
