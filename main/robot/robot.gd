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

@export var voices: Array[AudioStream]
var voice: AudioStream
var voice_pitch: float = 1.0

@export var comes_phrases: Array[String] = []
@export var goes_satisfied_phrases: Array[String] = []
@export var goes_unsatisfied_phrases: Array[String] = []
@export var drill_phrases: Array[String] = []
@export var polish_phrases: Array[String] = []
@export var paint_phrases: Array[String] = []
@export var saw_phrases: Array[String] = []
@export var part_replacement_phrases: Array[String] = []
@export var x_ray_phrases: Array[String] = []


var requirements: Array[Requirement]

const REQUIREMENT_PRICES: Dictionary = {
	Requirement.Type.REPAIR: 50.0,
	Requirement.Type.POLISHING: 75.0,
	Requirement.Type.PAINTING: 100.0,
	Requirement.Type.REPLACEMENT: 150.0
}

const BODY_PART_WEIGHT: float = 3.0
const WRECKNESS_WEIGHT: float = 2.0
const RUST_WEIGHT: float = 1.0
const COLOR_WEIGHT: float = 1.0

func _ready() -> void:
	voice_pitch += randf_range(-20.0, 20.0)
	voice = voices.pick_random()
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
			var random_part = randi() % textures_amount
			part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(part.type, random_part)
			part.current_body_part = random_part
		
	generate_requirements()


func generate_requirements() -> void:
	requirements.clear()

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


func calculate_quality() -> float:
	var total_quality: float = 0.0
	var total_weight: float = 0.0

	for part in custom_parts:
		if part.durability <= 0:
			continue

		if part.prefered_body_part >= 0:
			total_weight += BODY_PART_WEIGHT
			if part.current_body_part == part.prefered_body_part:
				total_quality += BODY_PART_WEIGHT

		if part.can_wreck:
			total_weight += WRECKNESS_WEIGHT
			total_quality += (1.0 - part.wreckness) * WRECKNESS_WEIGHT

		if part.can_rust:
			total_weight += RUST_WEIGHT
			var rust_quality: float = (part.rust_level + 1.0) / 2.0
			total_quality += rust_quality * RUST_WEIGHT

		if part.has_color:
			total_weight += COLOR_WEIGHT
			var color_quality: float = get_color_quality(
				part.current_color,
				part.prefered_color
			)
			total_quality += color_quality * COLOR_WEIGHT

	if total_weight <= 0.0:
		return 100.0

	return total_quality / total_weight * 100.0


func get_color_quality(current: Color, preferred: Color) -> float:
	var distance: float = sqrt(
		pow(current.r - preferred.r, 2.0)
		+ pow(current.g - preferred.g, 2.0)
		+ pow(current.b - preferred.b, 2.0)
	)

	return clampf(1.0 - distance / sqrt(3.0), 0.0, 1.0)
	

func calculate_revenue() -> int:
	var base_revenue: float = 0.0

	for requirement in requirements:
		if requirement.completed:
			base_revenue += REQUIREMENT_PRICES.get(requirement.type, 0.0)

	return int(base_revenue * calculate_quality() / 100.0)
