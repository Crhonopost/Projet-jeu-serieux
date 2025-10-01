extends Node


func _ready() -> void:
	await get_tree().create_timer(3).timeout
	$Button.visible = true
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/current_level.tscn")
