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
static var static_color_palette: Array[Color]

var requirements: Array[Requirement]

func _ready() -> void:
	static_color_palette = color_palette
	generate()
	Global.current_robot = self

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
			part.set_rust_level(0.0, false)

		if part.can_wreck:
			part.set_wreckness(0.0, false)

		if part.has_color:
			part.prefered_color = main_color
			part.change_color(main_color, false)

		var textures_amount = Global.BODY_PART_DATABASE.get_body_part_array_size(part.type)
		if textures_amount > 0:
			part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(
				part.type,
				randi() % textures_amount
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
