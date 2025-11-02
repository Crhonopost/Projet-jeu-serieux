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
	
	var first_condition = level_data.done
	var second_condition = level_data.player_steps <= roundi(level_data.optimal_steps * 1.5)
	var third_condition = level_data.player_steps <= level_data.optimal_steps
	
	if first_condition:
		setGolderStar($LevelContainer/Stars/Star1)
	if second_condition:
		setGolderStar($LevelContainer/Stars/Star2)
	if third_condition:
		setGolderStar($LevelContainer/Stars/Star3)
