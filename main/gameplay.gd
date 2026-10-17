extends Node
class_name GameScene

var current_item: Item
var unlocked_items: Array[Item]

@onready var current_item_node: TextureRect = %CurrentItemNode

func _ready() -> void:
	Global.game_scene = self


func change_item(item: Item):
	current_item = item
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
		add_child(robot)
		

func check_result() -> void:
	pass
