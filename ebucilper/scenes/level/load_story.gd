extends Node

var current_text: int = 0
var current_level: LevelResource

func _ready() -> void:
	current_level = ActiveLevel.level
	$Background.texture = current_level.background
	_show_current_text()
	

func _show_current_text() -> void:
	var entry = current_level.texts[current_text]
	
	$Banner/Label.text = entry.text
	if(entry.character_icon):
		$Character.texture = entry.character_icon
	
	await get_tree().create_timer(3).timeout
	
	if current_level.texts.size() == 1:
		$Button.text = "Start"
	else:
		$Button.text = "Next"
	$Button.visible = true


func _on_button_pressed() -> void:
	if current_text == current_level.texts.size() - 1:
		get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
	else:
		$Button.visible = false
		current_text += 1
		_show_current_text()

func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
