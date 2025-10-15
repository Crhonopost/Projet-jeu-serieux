extends Node

var level_id : String = ActiveLevel.level_id
var level_name : String = ActiveLevel.level_name
var level_path : String = ActiveLevel.level_path

var current_text : int = 0
var texts : Array = []

func _ready() -> void:
	$Background.texture = load(level_path + "/background.png")
	var json_string = FileAccess.get_file_as_string(level_path + "/texts.json")
	var data = JSON.parse_string(json_string)
	
	if typeof(data) == TYPE_ARRAY:
		texts = data
	else:
		push_error("Error: el JSON no contiene un arreglo de strings")
		
	$Banner/Label.text = texts[current_text]
	await get_tree().create_timer(5).timeout
	
	if texts.size() == 1 :
		$Button.text = "Start"
	else : 
		$Button.text = "Next"
	$Button.visible = true

func _on_button_pressed() -> void:
	if current_text == texts.size() - 1:
		get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
	else:
		$Button.visible = false
		current_text += 1
		$Banner/Label.text = texts[current_text]
		await get_tree().create_timer(3).timeout
		if current_text == texts.size() - 1 :
			$Button.text = "Start"
		$Button.visible = true
