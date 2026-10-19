extends TextureRect

var mouse_pressed: bool = false

@onready var drill: TextureRect = $Drill
@onready var polisher: TextureRect = $Polisher
@onready var paint: TextureRect = $Paint
@onready var paint_color: TextureRect = $Paint/PaintColor
@onready var saw: TextureRect = $Saw


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

	
func change_item(item: Item):
	Global.shake_control(self, 10, 0.3)
	return_item()
		
	Global.game_scene.current_item = item
	Global.game_scene.current_item.modulate = Color(0.2, 0.2, 0.2, 1.0)

	
	match item.type:
		Item.ItemType.DRILL:
			drill.show()
			Global.game_scene.hide_paint_drawer()
		Item.ItemType.POLISHER:
			polisher.show()
			Global.game_scene.hide_paint_drawer()
		Item.ItemType.PAINT:
			paint.show()
			if Global.game_scene.is_paint_drawer_active:
				Global.game_scene.hide_paint_drawer()
			else:
				Global.game_scene.show_paint_drawer()
		Item.ItemType.SAW:
			saw.show()
			Global.game_scene.hide_paint_drawer()
			
func return_item():
	if Global.game_scene.current_item:
		Global.game_scene.current_item.modulate = Color.WHITE
		Global.game_scene.current_item = null
	drill.hide()
	polisher.hide()
	paint.hide()
	saw.hide()
