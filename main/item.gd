extends TextureRect
class_name Item

var title: String = "unknown"
@export var price: int = 0
@export var avaible: bool = false

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
