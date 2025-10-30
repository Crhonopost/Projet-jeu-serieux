extends Control

signal check_grid

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid

@export var dev_mode: bool = true                 # developpement mode
var level_name : String = ActiveLevel.level_name
var level_path : String = ActiveLevel.level_path

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
	# wait for the cursor back to start
	await gridView.move_to_start(builder.cursorPosition, builder.cursorOrientation) 
	builder.build(instructions)
	#gridView.placeBlocs(builder.grid, false)
	gridView.placePlayerBlocs()
	gridView.showTargetBlock(gridView.mode, true, Vector3i.ZERO)
	check_grid.emit()
	
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

	var file_path := level_path + "/target.json"
	var f := FileAccess.open(file_path, FileAccess.WRITE)
	f.store_string(JSON.stringify(payload, "\t"))
	f.close()

	print("Saved target to: ", file_path)


func _load_target_from_json():
	var file_path := level_path + "/target.json"
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
	
	$CodingSpace.setTip(ActiveLevel.level_tip)

var mouse_over_viewport = false

func _input(event: InputEvent) -> void:
	if(event.is_action("move_camera")):
		$SubViewportContainer/SubViewport/Grid.get_node("CameraTarget/OrbitCamera").follow_mouse = mouse_over_viewport && event.is_action_pressed("move_camera")
	

func _on_sub_viewport_container_mouse_entered() -> void:
	mouse_over_viewport = true


func _on_sub_viewport_container_mouse_exited() -> void:
	mouse_over_viewport = false


func _on_grid_level_complete() -> void:
	$CodingSpace.setTip("gagné")
