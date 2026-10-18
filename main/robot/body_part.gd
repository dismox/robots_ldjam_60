extends TextureRect
class_name BodyPart

@export var type: Type

@export var current_color: Color = Color.WHITE
@export var prefered_color: Color = Color.WHITE
@export var prefered_body_part: int
@export var current_body_part: int

@export var can_wreck: bool = true
@export var wreckness: float = 0.0

@export var can_rust: bool = true
@export var rust_level: float = 0.0


@export var has_color: bool = true
@export var is_shaking: bool = false

var defects

var shake_strength: float = 1.0
@export var target_shake_strength: float = 1.0
var shake_speed: float = 50000.0

var modulation_tween: Tween

var is_mouse_hovered: bool = false

var particles: GPUParticles2D

enum Type {
	HEAD,
	HEAD_TOP,
	NOSE,
	EYES,
	MOUTH,
	EARS,
	BODY_TOP,
	BODY_BOTTOM,
	ARM,
	SHOULDER,
	BRAIN,
	HEART,
	GUTS
}

func _ready() -> void:
	if $BoltParticles:
		particles = $BoltParticles
		particles.modulate = current_color

func _process(delta: float) -> void:
	if is_mouse_hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var item = Global.game_scene.current_item
		if item:
			item.process_item(self)
	
	if !is_shaking:
		return
	shake_strength = lerpf(
		shake_strength,
		target_shake_strength,
		1.0 - exp(delta)
	)

	var offset := Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)

	self.offset_transform_position = offset

func set_shake_strength(value: float) -> void:
	target_shake_strength = maxf(value, 0.0)

func set_wreckness(value: float) -> void:
	value = clamp(value, 0.0, 1.0)
	wreckness = value
	#target_shake_strength = wreckness
	if particles:
		if value > 0.0:
			particles.emitting = true
			particles.amount = int(value * 10)
		else:
			if $SparkParticles:
				$SparkParticles.emitting = true
			if $SparkParticles2:
				$SparkParticles2.emitting = true
			particles.emitting = false

func change_color(color: Color):
	self_modulate = color
	current_color = self_modulate
	if particles:
		particles.modulate = self_modulate /  2.0
		particles.modulate.a = 1.0
	if current_color == prefered_color:
		if $SparkParticles:
			$SparkParticles.emitting = true
		if $SparkParticles2:
			$SparkParticles2.emitting = true

func paint(color: Color, delta: float) -> void:
	var new_color := current_color.lerp(color, 1.0 - exp(-10.0 * delta))

	if absf(new_color.r - prefered_color.r) < 0.1 \
	and absf(new_color.g - prefered_color.g) < 0.1 \
	and absf(new_color.b - prefered_color.b) < 0.1:
		new_color = prefered_color

	change_color(new_color)
	

func change_body_part(type: Type, texture_id: int) -> void:
	texture = Global.body_part_database.get_body_part_texture(type, texture_id)
	current_body_part = texture_id

func set_rust_level(value: float) -> void:
	value = clamp(value, -1.0, 1.0)
	rust_level = value
	if rust_level == -1.0:
		if $SparkParticles:
			$SparkParticles.emitting = true
		if $SparkParticles2:
			$SparkParticles2.emitting = true
		return
	var rust_material := material as ShaderMaterial
	rust_material.set_shader_parameter("rust_strength", rust_level)

func _on_mouse_entered() -> void:
	is_mouse_hovered = true
	Global.shake_control(self)
	#if Global.game_state != Global.GameState.GAMEPLAY_XRAY:
	#	self_modulate += Color(2.0, 2.0, 2.0, 1.0)

func _on_mouse_exited() -> void:
	is_mouse_hovered = false
	#if Global.game_state != Global.GameState.GAMEPLAY_XRAY:
	#	self_modulate -= Color(2.0, 2.0, 2.0, 1.0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Global.shake_control(self, 10, 0.1)


	
