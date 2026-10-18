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


func _ready() -> void:
	generate()
	Global.current_robot = self

func generate():
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
			part.set_wreckness(randf())
		if part.has_color:
			part.prefered_color = main_color
			part.change_color(main_color)
		part.texture = Global.BODY_PART_DATABASE.get_body_part_texture(part.type, randi() % 5)
		#part.size = Vector2.ZERO
	var random_color_parts_amount: int = randi() % 3
	if random_color_parts_amount > 0:
		for i in range(random_color_parts_amount):
			var part = custom_parts.pick_random()
			if part.has_color:
				part.change_color(remain_palette.pick_random())
				#part.change_color(Color.from_hsv(randf(), 0.7, 1.0, 1.5))
