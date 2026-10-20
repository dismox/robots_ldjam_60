extends Robot
class_name Villian

@export var original_parts: Array[BodyPart]
var times_arrived: int = 0

func _ready() -> void:
	Global.villian = self
	voice_pitch = -5.0
	main_color = color_palette.pick_random()


func generate() -> void:
	requirements.clear()

	for part in original_parts:
		if part.is_connected("mouse_entered", part._on_mouse_entered):
			pass
		else:
			part.connect("mouse_entered", part._on_mouse_entered)

		if not part.is_connected("mouse_exited", part._on_mouse_exited):
			part.connect("mouse_exited", part._on_mouse_exited)

		if not part.is_connected("gui_input", part._on_gui_input):
			part.connect("gui_input", part._on_gui_input)

		if part.can_rust:
			part.set_rust_level(0.0, false)

		if part.can_wreck:
			part.set_wreckness(0.0, false)

		#if part.has_color and part.current_body_part != -2:
		#	part.prefered_color = main_color
		#	part.change_color(main_color, false)
			
		part.current_body_part = -2

		#var textures_amount = Global.BODY_PART_DATABASE.get_body_part_array_size(part.type)
		#if textures_amount > 0:
		#	var random_part = randi() % textures_amount
		#	part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(part.type, random_part)
		#	part.current_body_part = random_part
		
	new_custom_parts()
	generate_requirements()
	


func new_custom_parts() -> void:
	if times_arrived <= 0:
		return

	var parts_to_add: int = 4 #mini(times_arrived, original_parts.size())
	if times_arrived >= 4:
		parts_to_add += 2

	for i in range(parts_to_add):
		var new_part: BodyPart = original_parts.pop_at(0)

		if new_part == null:
			continue

		custom_parts.append(new_part)

		var textures_amount: int = Global.BODY_PART_DATABASE.get_body_part_array_size(
			new_part.type
		)

		if textures_amount > 0:
			var random_part: int = randi_range(0, textures_amount - 1)
			new_part.change_body_part(new_part.type, random_part, false)
			new_part.prefered_body_part = new_part.current_body_part
			if new_part.type != BodyPartType.Type.EYES:
				new_part.has_color = true

		if new_part.has_color:
			new_part.prefered_color = main_color
			new_part.change_color(main_color, false)
			


func generate_requirements() -> void:
	requirements.clear()

	for part in original_parts:
		if Item.ItemType.SAW in Global.unlocked_items:
			if randf() > 0.8:
				var requirement := Requirement.new()
				requirement.init(Requirement.Type.REPLACEMENT, part)
				requirements.append(requirement)
				var size = Global.BODY_PART_DATABASE.get_body_part_array_size(part.type)
				part.prefered_body_part = randi_range(0, size - 1)
				if part.prefered_body_part == part.current_body_part:
					if part.prefered_body_part != 0:
						part.prefered_body_part -= 1
					else:
						part.prefered_body_part += 1
		if Item.ItemType.DRILL in Global.unlocked_items:
			if part.can_wreck and randf() > 0.6:
				part.set_wreckness(randf())

				if part.wreckness > 0.0:
					var requirement := Requirement.new()
					requirement.init(Requirement.Type.REPAIR, part)
					requirements.append(requirement)

		if Item.ItemType.POLISHER in Global.unlocked_items:
			if part.can_rust and randf() > 0.6:
				part.set_rust_level(randf())

				if part.rust_level > 0.0:
					var requirement := Requirement.new()
					requirement.init(Requirement.Type.POLISHING, part)
					requirements.append(requirement)

	for part in custom_parts:
		if Item.ItemType.SAW in Global.unlocked_items:
			if randf() > 0.8:
				var requirement := Requirement.new()
				requirement.init(Requirement.Type.REPLACEMENT, part)
				requirements.append(requirement)
				var size = Global.BODY_PART_DATABASE.get_body_part_array_size(part.type)
				part.prefered_body_part = randi_range(0, size - 1)
				if part.prefered_body_part == part.current_body_part:
					if part.prefered_body_part != 0:
						part.prefered_body_part -= 1
					else:
						part.prefered_body_part += 1
		if Item.ItemType.DRILL in Global.unlocked_items:
			if part.can_wreck and randf() > 0.6:
				part.set_wreckness(randf())

				if part.wreckness > 0.0:
					var requirement := Requirement.new()
					requirement.init(Requirement.Type.REPAIR, part)
					requirements.append(requirement)

		if Item.ItemType.POLISHER in Global.unlocked_items:
			if part.can_rust and randf() > 0.6:
				part.set_rust_level(randf())

				if part.rust_level > 0.0:
					var requirement := Requirement.new()
					requirement.init(Requirement.Type.POLISHING, part)
					requirements.append(requirement)
					
		if Item.ItemType.PAINT in Global.unlocked_items:
			if part.has_color and randf() > 0.9:
				var available_colors: Array[Color] = []

				for color in color_palette:
					if color != part.current_color:
						available_colors.append(color)

				if not available_colors.is_empty():
					part.change_color(available_colors.pick_random())

					var requirement := Requirement.new()
					requirement.init(Requirement.Type.PAINTING, part)
					requirements.append(requirement)
					
		
		# REPLACEMENT пока не генерируется.
