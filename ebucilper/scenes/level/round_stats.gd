extends Control

@export var completed_color: Color

signal keep_playing_selected
signal next_selected

func load_level(level: LevelResource):
	$List/LevelName.text = level.name
	
	$List/Stars/Second/Title.text = "Steps needed :" + str(roundi(level.optimal_steps * 1.5)) 
	$List/Stars/Second/Player.text = "Yours : " + str(level.player_steps)
	
	$List/Stars/Third/Title.text = "Steps needed :" + str(level.optimal_steps)
	$List/Stars/Third/Player.text = "Yours : " + str(level.player_steps)
	
	var first_condition = level.done
	var second_condition = level.player_steps <= roundi(level.optimal_steps * 1.5)
	var third_condition = level.player_steps <= level.optimal_steps
	
	
	$List/Stars/First/Star.modulate = completed_color if first_condition else Color.WHITE
	$List/Stars/Second/Star.modulate = completed_color if second_condition else Color.WHITE
	$List/Stars/Third/Star.modulate = completed_color if third_condition else Color.WHITE


func _on_stay_pressed() -> void:
	keep_playing_selected.emit()


func _on_continue_pressed() -> void:
	next_selected.emit()
