extends Node

#var body_part_database: BodyPartsDatabase = BodyPartsDatabase.new()
var game_state: GameState
var money: int = 2000
var game_scene: GameScene
var current_robot: Robot

var current_text
var text_queue: Array[String]

const BODY_PART_DATABASE = preload(
	"res://main/all_body_parts.tres"
)

const ROBOT_PALETTE = preload(
	"res://main/robot_palette.tres"
)

enum GameState {
	MAIN_MENU,
	GAMEPLAY_NORMAL,
	GAMEPLAY_XRAY
}

var unlocked_items: Array[Item.ItemType] = [Item.ItemType.DRILL]

signal money_changed(value: int)

func _ready() -> void:
	print("DATABASE: ", BODY_PART_DATABASE)
	print("PALETTE: ", ROBOT_PALETTE)

	print("DATABASE SCRIPT: ", BODY_PART_DATABASE.get_script())
	print("PALETTE SCRIPT: ", ROBOT_PALETTE.get_script())

	for property in BODY_PART_DATABASE.get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			print(
				property.name,
				": ",
				BODY_PART_DATABASE.get(property.name)
			)

	for property in ROBOT_PALETTE.get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			print(
				property.name,
				": ",
				ROBOT_PALETTE.get(property.name)
			)

func set_money(value: int):
	if value > money:
		AudioManager.play_sound("res://main/assets/sounds/buy.wav", Vector2(-10.0, 10.0))
	money = value
	money_changed.emit(money)

func move_to(node: Node, target_position: Vector2, duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node, "position", target_position, duration)

func shake_control(control: Control, strength: float = 10.0, duration: float = 0.3) -> void:
	var original_position := control.position
	var tween := create_tween()

	var steps := 8
	var step_duration := duration / steps

	for i in steps:
		var offset := Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)

		tween.tween_property(
			control,
			"offset_transform_position",
			offset,
			step_duration
		)

	tween.tween_property(control, "offset_transform_position", Vector2.ZERO, step_duration)
