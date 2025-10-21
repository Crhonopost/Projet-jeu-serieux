extends Control

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid

@export var dev_mode: bool = true                 # developpement mode
@export var level_name: String = "level_001"      # can be changed in inspector

func _ready():
	_load_target_from_json()

func _on_coding_space_launch() -> void:
	var instructions = $CodingSpace.retrieveInstructions()
	#gridView.clearGrid()
	#builder.grid = gridView.currentGrid
	gridView.clear_player()
	builder.grid = gridView.playerGrid
	gridView.playerGrid.gridScale = gridView.currentGrid.gridScale
	gridView.playerGrid.clear()
	
	builder.resetState()
	builder.build(instructions)
	#gridView.placeBlocs(builder.grid, false)
	gridView.placePlayerBlocs()
	gridView.showTargetBlock(gridView.mode, true, Vector3i.ZERO)
	
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


func _load_target_from_json():
	var file_path := "res://scenes/level/design_level_json/%s.json" % level_name
	if not FileAccess.file_exists(file_path):
		push_error("Target JSON file not found: %s" % file_path)
		return

	var f := FileAccess.open(file_path, FileAccess.READ)
	var json_str := f.get_as_text()
	f.close()

	var result = JSON.parse_string(json_str)
	if result == null:
		push_error("Failed to parse JSON: %s" % file_path)
		return

	var grid_data = result.get("grid_data", null)
	if grid_data == null:
		push_error("No 'grid_data' found in JSON.")
		return

	var new_grid = GridResource.new()
	new_grid.from_serializable_dict(grid_data)
	gridView.currentGrid = new_grid
	gridView.showTargetBlock(gridView.mode, true, Vector3i(0, 0, 0))
