extends Node


@onready var levelIntroductionScene : PackedScene = load("res://scenes/level/level_introduction.tscn")
@onready var levelScene : PackedScene = load("res://scenes/level/current_level.tscn")

var game_instance: Node

func _on_level_level_selected(level: LevelResource) -> void:
	$TextureRect.visible = false
	
	if(game_instance):
		game_instance.queue_free()
	
	game_instance = levelIntroductionScene.instantiate()
	ActiveLevel.level = level
	game_instance.current_level = level
	add_child(game_instance)
	game_instance.connect("launch_level", _on_introduction_finished)

func _on_introduction_finished():
	game_instance.queue_free()
	
	game_instance = levelScene.instantiate()
	game_instance.connect("leave", go_home)
	game_instance.level = ActiveLevel.level
	add_child(game_instance)

func go_home():
	$TextureRect.visible = true
	if(game_instance):
		game_instance.queue_free()
