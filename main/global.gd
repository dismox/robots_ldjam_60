extends Node

#var body_part_database: BodyPartsDatabase = BodyPartsDatabase.new()
var game_state: GameState
var money: int = 0
var game_scene: GameScene
var current_robot: Robot

const BODY_PART_DATABASE: BodyPartsDatabase = preload(
	"res://main/all_body_parts.tres"
)

enum GameState {
	MAIN_MENU,
	GAMEPLAY_NORMAL,
	GAMEPLAY_XRAY
}

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
