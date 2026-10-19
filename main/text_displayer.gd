extends Panel

const text_sound: AudioStream = preload("res://main/assets/sounds/text.wav")

@onready var text_label: Label = %TextLabel
@onready var text_animator: AnimationPlayer = %TextAnimator

var base_char_delay: float = 0.04
var word_pause: float = 0.02
var sentence_pause: float = 0.3
var comma_pause: float = 0.04
var exclamation_speed_multiplier: float = 0.7

var _is_running: bool = false
var _skip: bool = false

signal dialogue_finished

func _ready() -> void:
	Global.current_text = self

func type_text() -> void:
	#_skip = false
	show()
	if _is_running:
		_skip = true
		await dialogue_finished

	_is_running = true
	_skip = false

	#label.bbcode_enabled = true
	if Global.text_queue.size() <= 0:
		return
	var label = text_label
	var text = Global.text_queue.pop_at(0)
	
	label.text = text
	label.visible_characters = 0

	var plain_text = label.text #.get_parsed_text()
	var sentences = _split_into_sentences(plain_text)

	var visible_index := 0

	for sentence in sentences:
		if _skip:
			emit_signal("dialogue_ended")
			break

		var speed_multiplier := 1.0
		if sentence.strip_edges().ends_with("!"):
			speed_multiplier = exclamation_speed_multiplier

		for c in sentence:
			if _skip:
				emit_signal("dialogue_ended")
				break

			#if !voice.is_empty():
				#AudioManager.play_ui(voice.pick_random(), 0)
				
			#AudioManager.play_sound(text_sound, Vector2(-1.0, 1.0))
			AudioManager.play_sound(Global.current_robot.voice, Vector2(Global.current_robot.voice_pitch - 1.0, Global.current_robot.voice_pitch + 1.0))
			visible_index += 1
			label.visible_characters = visible_index

			if c == " ":
				await get_tree().create_timer(word_pause).timeout
			elif c == ",":
				await get_tree().create_timer(comma_pause).timeout
			else:
				await get_tree().create_timer(base_char_delay * speed_multiplier).timeout

		await get_tree().create_timer(sentence_pause).timeout

	if label:
		label.visible_characters = -1
	_is_running = false
	dialogue_finished.emit()


func skip() -> void:
	_skip = true


func _split_into_sentences(text: String) -> Array[String]:
	var result: Array[String] = []
	var current := ""

	for c in text:
		current += c
		if c == "." or c == "!" or c == "?":
			result.append(current)
			current = ""

	if current != "":
		result.append(current)

	return result


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skip()
		if !_is_running:
			if Global.text_queue.is_empty():
				hide()
			else:
				type_text()
