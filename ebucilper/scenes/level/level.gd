extends Control

@export var level_data: LevelResource

signal level_selected(level: LevelResource)

func _ready() -> void:
	# Load from game progress
	# unlocked = false
	# done = false
	# steps = 7
	
	update_level()
	
func setGolderStar(starNode: TextureRect) -> void:
	starNode.modulate.b = 0
	starNode.modulate.g = 0.8

func _on_button_pressed() -> void:
	level_selected.emit(level_data)

func update_level()->void:
	$LevelContainer/Name.text = level_data.name
	if not level_data.unlocked:
		$LevelContainer/Icon.texture = load("res://Assets/Images/lock.png")	
		$LevelContainer/Stars.visible = false
		$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		$LevelContainer/Stars.visible = true
		$Button.mouse_filter = Control.MOUSE_FILTER_STOP
		if level_data.done:
			$LevelContainer/Icon.texture = level_data.completed_icon
		else:
			$LevelContainer/Icon.texture = level_data.to_be_done_icon
	
	if level_data.done:
		if level_data.steps <= level_data.target_steps:
			setGolderStar($LevelContainer/Stars/Star1)
			
		if level_data.steps < level_data.target_steps:
			setGolderStar($LevelContainer/Stars/Star2)
			
		if level_data.steps <= level_data.optimal_steps:
			setGolderStar($LevelContainer/Stars/Star3)
