extends Node2D
class_name Robot

@onready var wireframe: TextureRect = %Wireframe
@onready var head: TextureRect = %Head
@onready var head_top: TextureRect = %HeadTop
@onready var nose: TextureRect = %Nose
@onready var eyes: TextureRect = %Eyes
@onready var mouth: TextureRect = %Mouth
@onready var ears: TextureRect = %Ears
@onready var body_top: TextureRect = %BodyTop
@onready var body_bottom: TextureRect = %BodyBottom
@onready var left_arm: TextureRect = %LeftArm
@onready var left_shoulder: TextureRect = %LeftShoulder
@onready var right_arm: TextureRect = %RightArm
@onready var right_shoulder: TextureRect = %RightShoulder

@onready var brain: TextureRect = %Brain
@onready var heart: TextureRect = %Heart
@onready var guts: TextureRect = %Guts

@export var custom_parts: Array[BodyPart]
@export var inside_parts: Array[BodyPart]

var main_color: Color = Color.WHITE

@export var color_palette: Array[Color] 

var requirements: Array[Requirement]

func _ready() -> void:
	generate()
	Global.current_robot = self

func _generate():
	main_color = color_palette.pick_random()
	var remain_palette = color_palette
	remain_palette.pop_at(color_palette.find(color_palette))
	for part in custom_parts:
		part.connect("mouse_entered", part._on_mouse_entered)
		part.connect("mouse_exited", part._on_mouse_exited)
		part.connect("gui_input", part._on_gui_input)
		if part.can_rust:
			part.set_rust_level(randf())
		if part.can_wreck:
			if randf() > 0.6:
				part.set_wreckness(randf())
			else:
				part.set_wreckness(0.0)
		if part.has_color:
			part.prefered_color = main_color
			part.change_color(main_color)
		part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(part.type, randi() % 6)
		#part.size = Vector2.ZERO
	var random_color_parts_amount: int = randi() % 3
	if random_color_parts_amount > 0:
		for i in range(random_color_parts_amount):
			var part = custom_parts.pick_random()
			if part.has_color:
				part.change_color(remain_palette.pick_random())
				#part.change_color(Color.from_hsv(randf(), 0.7, 1.0, 1.5))
				
	generate_requirements()


func _generate_requirements() -> void:
	requirements.clear()

	for part in custom_parts:
		if part.can_wreck and part.wreckness > 0.0:
			var requirement := Requirement.new()

			if part.wreckness > 0.0:
				requirement.init(Requirement.Type.REPAIR, part)
			#else:
			#	requirement.init(Requirement.Type.REPAIR, part)

			requirements.append(requirement)

		if part.can_rust and part.rust_level > 0.0:
			var requirement := Requirement.new()
			requirement.init(Requirement.Type.POLISHING, part)
			requirements.append(requirement)

		if part.has_color and part.current_color != main_color:
			var requirement := Requirement.new()
			requirement.init(Requirement.Type.PAINTING, part)
			requirements.append(requirement)


func generate() -> void:
	requirements.clear()
	main_color = color_palette.pick_random()

	for part in custom_parts:
		if part.is_connected("mouse_entered", part._on_mouse_entered):
			pass
		else:
			part.connect("mouse_entered", part._on_mouse_entered)

		if not part.is_connected("mouse_exited", part._on_mouse_exited):
			part.connect("mouse_exited", part._on_mouse_exited)

		if not part.is_connected("gui_input", part._on_gui_input):
			part.connect("gui_input", part._on_gui_input)

		if part.can_rust:
			part.set_rust_level(0.0)

		if part.can_wreck:
			part.set_wreckness(0.0)

		if part.has_color:
			part.prefered_color = main_color
			part.change_color(main_color)

		part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(
			part.type,
			randi() % 6
		)
		
	generate_requirements()


func generate_requirements() -> void:
	requirements.clear()

	for part in custom_parts:
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
					
		if Item.ItemType.SAW in Global.unlocked_items:
			pass
		# REPLACEMENT пока не генерируется.
