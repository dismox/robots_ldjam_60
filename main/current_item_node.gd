extends TextureRect

var mouse_pressed: bool = false

func _process(_delta: float) -> void:
	position = get_global_mouse_position() - size/6

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_pressed = true
		emit_particles(mouse_pressed)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		mouse_pressed = false
		emit_particles(mouse_pressed)
		
func emit_particles(value: bool):
	%DrillParticles.emitting = false
	%PolisherParticles.emitting = false
	%PaintParticles.emitting = false
	%SawParticles.emitting = false
	if Global.game_scene.current_item:
		match Global.game_scene.current_item.type:
			Item.ItemType.DRILL:
				%DrillParticles.emitting = value
			Item.ItemType.POLISHER:
				%PolisherParticles.emitting = value
			Item.ItemType.PAINT:
				%PaintParticles.emitting = value
			Item.ItemType.SAW:
				%SawParticles.emitting = value
