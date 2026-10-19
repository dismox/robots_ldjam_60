extends Node2D

func ready() -> void:
	for i in range(100):
		var new_head = %Head.duplicate(DUPLICATE_SCRIPTS)
		var color = Global.ROBOT_PALETTE.color_palette.pick_random()
		new_head.change_color(color, false)
		add_child(new_head)
		new_head.global_position = Vector2(randi_range(0, 1920), randi_range(0, 1080))
		new_head.z_index = 10 * i
		if i % 2 == 0:
			new_head.modulate = Color(0.525, 0.525, 0.525, 1.0)
		if i % 2 == 0:
			new_head.modulate = Color(0.3, 0.3, 0.3, 1.0)
		else:
			new_head.modulate = Color(0.696, 0.696, 0.696, 1.0)
		#new_head.modulate = Color(10.0 / i / 10, 10.0 / i / 10, 10.0 / i / 10, 1.0) 
		new_head.rotation_degrees = randi_range(-360, 360)
		randomize_part(new_head)
		for part in new_head.get_children():
			if part is BodyPart:
				randomize_part(part)
				if part.has_color:
					part.change_color(color, false)
		
				
func randomize_part(part: BodyPart):
	var textures_amount = Global.BODY_PART_DATABASE.get_body_part_array_size(part.type)
	if textures_amount > 0:
		var random_part = randi() % textures_amount
		part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(part.type, random_part)
		part.current_body_part = random_part


func _on_button_pressed() -> void:
	var color = Global.ROBOT_PALETTE.color_palette.pick_random()
	%Head.change_color(color, false)
	%Head.set_rust_level(-0.5)
	randomize_part(%Head)
	for part in %Head.get_children():
		if part is BodyPart:
			randomize_part(part)
			if part.has_color:
				part.change_color(color, false)
			if part.can_rust:
				part.set_rust_level(-0.5)
