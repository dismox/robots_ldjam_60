extends Node
class_name GameScene

var current_item: Item
var unlocked_items: Array[Item]

@onready var current_item_node: TextureRect = %CurrentItemNode

@onready var robot_start_position: Marker2D = %RobotStartPosition
@onready var robot_end_position: Marker2D = %RobotEndPosition
@onready var x_ray: TextureRect = %XRay

func _ready() -> void:
	Global.game_scene = self


func change_item(item: Item):
	if current_item:
		if current_item == item:
			current_item.self_modulate = Color.WHITE
			current_item_node.texture = null
		else:
			current_item.self_modulate = Color.WHITE
	current_item = item
	current_item.self_modulate = Color.TRANSPARENT
	current_item_node.texture = current_item.texture

func _on_x_ray_button_toggled(toggled_on: bool) -> void:
	if Global.current_robot:
		for part in Global.current_robot.custom_parts:
			if toggled_on:
				Global.move_to(x_ray, Vector2(x_ray.position.x, 30.0), 2.0)
				Global.game_state = Global.GameState.GAMEPLAY_XRAY
				if part.modulation_tween:
					part.modulation_tween.kill()
				part.modulation_tween = create_tween()
				part.modulation_tween.set_ease(Tween.EASE_OUT)
				part.modulation_tween.set_trans(Tween.TRANS_EXPO)
				part.modulation_tween.tween_property(part, "self_modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
				#part.self_modulate = Color(0.0, 0.0, 0.0, 1.0)
				Global.current_robot.wireframe.self_modulate = Color(0.0, 0.0, 0.0, 1.0)
			else:
				Global.move_to(x_ray, Vector2(x_ray.position.x, 1100.0), 2.0)
				Global.game_state = Global.GameState.GAMEPLAY_NORMAL
				if part.modulation_tween:
					part.modulation_tween.kill()
				part.modulation_tween = create_tween()
				part.modulation_tween.set_ease(Tween.EASE_OUT)
				part.modulation_tween.set_trans(Tween.TRANS_EXPO)
				part.modulation_tween.tween_property(part, "self_modulate", part.current_color, 0.5)
				#part.self_modulate = part.current_color
				Global.current_robot.wireframe.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		for part in Global.current_robot.inside_parts:
			part.visible = toggled_on


func _on_next_button_pressed() -> void:
	if Global.current_robot:
		check_result()
		Global.current_robot.queue_free()
		var new_robot_scene: PackedScene = load("res://main/robot/robot.tscn")
		var robot: Robot = new_robot_scene.instantiate()
		robot.generate()
		robot_start_position.add_child(robot)
		#robot.position = robot_start_position.global_position
		Global.move_to(robot, robot_end_position.global_position)
		for part in robot.custom_parts:
			Global.shake_control(part, 30.0)

func check_result() -> void:
	pass
