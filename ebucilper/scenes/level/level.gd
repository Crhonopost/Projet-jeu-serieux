extends Node

@export var level_id: String
@export var level_name : String
@export var level_path : String
@export var target_steps : int
@export var optimal_steps : int

@export var unlocked : bool = false
@export var done : bool = false
@export var steps : int

func _ready() -> void:
	# Load from game progress
	# unlocked = false
	# done = false
	# steps = 7
	
	$LevelContainer/Name.text = level_name
	if not unlocked:
		$LevelContainer/Icon.texture = load("res://Assets/Images/lock.png")	
		$LevelContainer/Stars.visible = false
	elif done:
		$LevelContainer/Icon.texture = load(level_path + "/icon.png")
	else:
		$LevelContainer/Icon.texture = load(level_path + "/icon_destroyed.png")
	
	if done:
		if steps <= target_steps:
			setGolderStar($LevelContainer/Stars/Star1)
			
		if steps < target_steps:
			setGolderStar($LevelContainer/Stars/Star2)
			
		if steps <= optimal_steps:
			setGolderStar($LevelContainer/Stars/Star3)
	
func setGolderStar(starNode: TextureRect) -> void:
	starNode.modulate.b = 0
	starNode.modulate.g = 0.8

func _on_button_pressed() -> void:
	# Set active level to the one clicked
	ActiveLevel.level_id = level_id
	ActiveLevel.level_name = level_name
	ActiveLevel.level_path = level_path
	
	get_tree().change_scene_to_file("res://scenes/level/level_introduction.tscn")
