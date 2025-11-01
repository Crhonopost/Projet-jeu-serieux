extends Node


@onready var levelIntroductionScene : PackedScene = load("res://scenes/level/level_introduction.tscn")
@onready var levelScene : PackedScene = load("res://scenes/level/current_level.tscn")

@export var levels: Array[LevelResource]

var game_instance: Node

func _enter_tree() -> void:
	for child in $TextureRect/LevelsList/ScrollContainer/LevelList.get_children():
		child.queue_free()
	
	var levelItemScene : PackedScene = load("res://scenes/UI/world/level.tscn")
	for i in range(levels.size()-1):
		var level := levels[i]
		levels[i+1].unlocked = level.done

		var l = levelItemScene.instantiate()
		l.level_data = level
		$TextureRect/LevelsList/ScrollContainer/LevelList.add_child(l)
		l.connect("level_selected", _on_level_selected)

func _on_level_selected(level: LevelResource) -> void:
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
	
	for i in range(levels.size()-1):
		var level := levels[i]
		levels[i+1].unlocked = level.done
		$TextureRect/LevelsList/ScrollContainer/LevelList.get_child(i).update_level()
