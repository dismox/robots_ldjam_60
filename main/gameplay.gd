extends Node
class_name GameScene

var current_item: Item
var unlocked_items: Array[Item]

@onready var current_item_node: TextureRect = %CurrentItemNode

@onready var robot_start_position: Marker2D = %RobotStartPosition
@onready var robot_end_position: Marker2D = %RobotEndPosition

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
				Global.game_state = Global.GameState.GAMEPLAY_XRAY
				part.self_modulate = Color(0.0, 0.0, 0.0, 1.0)
				Global.current_robot.wireframe.self_modulate = Color(0.0, 0.0, 0.0, 1.0)
			else:
				Global.game_state = Global.GameState.GAMEPLAY_NORMAL
				part.self_modulate = part.current_color
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
