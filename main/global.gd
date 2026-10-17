extends Node

var body_part_database: BodyPartsDatabase = BodyPartsDatabase.new()
var game_state: GameState

var game_scene: GameScene
var current_robot: Robot

enum GameState {
	MAIN_MENU,
	GAMEPLAY_NORMAL,
	GAMEPLAY_XRAY
}


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
