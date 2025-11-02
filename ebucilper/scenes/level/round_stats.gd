extends Control

@export var completed_color: Color

signal keep_playing_selected
signal next_selected

func load_level(level: LevelResource):
	$List/LevelName.text = level.name
	
	$List/Stars/StepCount/Title.text = "Optimal steps count: " + str(level.optimal_steps)
	$List/Stars/StepCount/Player.text = "Yours: " + str(level.player_steps)
	
	$List/Stars/InstructionCount/Title.text = "Optimal instruction count: " + str(level.optimal_instruction_count)
	$List/Stars/InstructionCount/Player.text = "Yours: " + str(level.player_instruction_count)
	
	var first_condition = level.done
	var second_condition = level.player_steps <= level.optimal_steps
	var third_condition = level.player_instruction_count <= level.optimal_instruction_count
	
	
	$List/Stars/First/Star.modulate = completed_color if first_condition else Color.WHITE
	$List/Stars/StepCount/Star.modulate = completed_color if second_condition else Color.WHITE
	$List/Stars/InstructionCount/Star.modulate = completed_color if third_condition else Color.WHITE


func _on_stay_pressed() -> void:
	keep_playing_selected.emit()


func _on_continue_pressed() -> void:
	next_selected.emit()
