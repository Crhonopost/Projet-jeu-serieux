extends Node


@onready var levelIntroductionScene : PackedScene = load("res://scenes/level/level_introduction.tscn")
@onready var levelScene : PackedScene = load("res://scenes/level/current_level.tscn")

@export var levels: Array[LevelResource]

var game_instance: Node

func _enter_tree() -> void:
	for child in $TextureRect/LevelsList/ScrollContainer/LevelList.get_children():
		child.queue_free()
	
	if OS.has_feature("build"):
		user_levels_init()
	
	var levelItemScene : PackedScene = load("res://scenes/UI/world/level.tscn")
	for i in range(levels.size()-1):
		var level := levels[i]
		levels[i+1].unlocked = level.done

		var l = levelItemScene.instantiate()
		l.level_data = level
		$TextureRect/LevelsList/ScrollContainer/LevelList.add_child(l)
		l.connect("level_selected", _on_level_selected)

func user_levels_init():
	for i in levels.size():
		var l = levels[i]
		var orig_path = l.resource_path
		if orig_path.begins_with("res://"):
			var filename = orig_path.get_file()
			var user_path = "user://%s" % filename
			if not FileAccess.file_exists(user_path):
				var copy = l.duplicate(true)
				copy.resource_path = user_path
				var err = ResourceSaver.save(copy)
				if err != OK:
					var lab = Label.new()
					lab.text = levels[i].resource_path
					lab.text = ("Echec de la copie de «%s» vers «%s»" % [orig_path, user_path])
					$VBoxContainer.add_child(lab)
				levels[i] = copy
			else:
				var loaded = ResourceLoader.load(user_path)
				if loaded:
					levels[i] = loaded
				else:
					push_error("Impossible de charger le user resource «%s»" % user_path)


func _on_level_selected(level: LevelResource) -> void:
	$TextureRect.visible = false
	
	if(game_instance):
		game_instance.queue_free()
	
	ActiveLevel.level = level
	if(level.id=="sandbox"):
		_on_introduction_finished()
		return
	
	game_instance = levelIntroductionScene.instantiate()
	game_instance.current_level = level
	add_child(game_instance)
	game_instance.connect("launch_level", _on_introduction_finished)

func _on_introduction_finished():
	if(game_instance):
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
