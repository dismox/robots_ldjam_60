extends TextureRect
class_name Item

@export var type: ItemType
@export var price: int = 0
@export var avaible: bool = false

enum ItemType {
	DRILL,
	POLISHER,
	PAINT,
	SAW
}

func _ready() -> void:
	if !avaible:
		self_modulate = Color(0.0, 0.0, 0.0, 1.0)
	$PriceTag/PriceTagLabel.text = str(price)
	if Global.money >= price:
		$PriceTag.self_modulate = Color.WHITE
	else:
		$PriceTag.self_modulate = Color.DIM_GRAY

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
			if !avaible:
				if price <= Global.money:
					Global.money -= price
					avaible = true
					$PriceTag.hide()
				else:
					return
			Global.game_scene.change_item(self)

func _on_mouse_entered() -> void:
	Global.shake_control(self)


func process_item(part: BodyPart) -> void:
	match type:
		ItemType.DRILL:
			if part.can_wreck:
				Global.shake_control(part, 10.0, 0.1)
				part.set_wreckness(part.wreckness - 0.01)
		ItemType.POLISHER:
			if part.can_rust:
				Global.shake_control(part, 10.0, 0.1)
				part.set_rust_level(part.rust_level - 0.01)
		ItemType.PAINT:
			pass
		ItemType.SAW:
			Global.shake_control(part, 20.0, 0.1)
