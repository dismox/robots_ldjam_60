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


func _change_item(item: Item):
	var current_item: Item = Global.game_scene.current_item
	if current_item:
		if current_item == item:
			current_item.self_modulate = Color.WHITE
			#current_item_node.texture = null
		else:
			current_item.self_modulate = Color.WHITE
	current_item = item
	current_item.self_modulate = Color.TRANSPARENT
	#current_item_node.texture = current_item.texture
	
	
func change_item(item: Item):
	if Global.game_scene.current_item:
		#if current_item == item:
		#	current_item.self_modulate = Color.WHITE
		Global.game_scene.current_item.self_modulate = Color.WHITE
	Global.game_scene.current_item = item
	Global.game_scene.current_item.self_modulate = Color.TRANSPARENT
		
	drill.hide()
	polisher.hide()
	paint.hide()
	saw.hide()
	
	match item.type:
		Item.ItemType.DRILL:
			drill.show()
		Item.ItemType.POLISHER:
			polisher.show()
		Item.ItemType.PAINT:
			paint.show()
		Item.ItemType.SAW:
			saw.show()

	
