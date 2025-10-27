extends Node

var level_id : String = ActiveLevel.level_id
var level_name : String = ActiveLevel.level_name
var level_path : String = ActiveLevel.level_path

var current_text: int = 0

var texts = []

func _ready() -> void:
	$Background.texture = load(level_path + "/background.png")

	var json_string = FileAccess.get_file_as_string(level_path + "/texts.json")
	var data = JSON.parse_string(json_string)
	
	var tip = ""
	if typeof(data) == TYPE_DICTIONARY and data.has("texts") and typeof(data["texts"]) == TYPE_ARRAY:
		texts = data["texts"]
		tip = data.get("tip", "")
	else:
		push_error("Error: el JSON no contiene la estructura esperada (texts como arreglo).")
		return
	
	ActiveLevel.level_tip = tip
	_show_current_text()
	

func _show_current_text() -> void:
	var entry = texts[current_text]
	
	var text_value = entry.get("text", "")
	var character_value = entry.get("character", "")
	
	$Banner/Label.text = text_value
	$Character.texture = load("res://Assets/Images/characters/" + character_value)
	
	await get_tree().create_timer(3).timeout
	
	if texts.size() == 1:
		$Button.text = "Start"
	else:
		$Button.text = "Next"
	$Button.visible = true


func _on_button_pressed() -> void:
	if current_text == texts.size() - 1:
		get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
	else:
		$Button.visible = false
		current_text += 1
		_show_current_text()

func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
