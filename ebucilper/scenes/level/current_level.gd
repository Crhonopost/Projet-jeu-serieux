extends Control

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid

@export var dev_mode: bool = true                 # developpement mode
@export var level_name: String = "level_001"      # can be changed in inspector

func _on_coding_space_launch() -> void:
	var instructions = $CodingSpace.retrieveInstructions()
	gridView.clearGrid()
	builder.grid = gridView.currentGrid
	builder.resetState()
	builder.build(instructions)
	gridView.placeBlocs(builder.grid, false)
	
func _unhandled_input(event: InputEvent) -> void:
	if dev_mode and event.is_action_pressed("dev_save_target"):
		_save_current_as_target()
		
func _save_current_as_target() -> void:
	if builder.grid == null:
		push_error("No grid to save.")
		return

	var payload := {
		"level": level_name,
		"building_time": builder.buildingTime,  
		"grid_data": builder.grid.to_serializable_dict()
	}

	var dir_path := "res://scenes/level/design_level_json" 
	if DirAccess.open(dir_path) == null:
		DirAccess.make_dir_absolute(dir_path)

	var file_path := "%s/%s.json" % [dir_path, level_name]
	var f := FileAccess.open(file_path, FileAccess.WRITE)
	f.store_string(JSON.stringify(payload, "\t"))
	f.close()

	print("Saved target to: ", file_path)
