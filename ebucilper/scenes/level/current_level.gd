extends Control

signal check_grid

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid

@export var dev_mode: bool = true                 # developpement mode

func _ready():
	_load_target()
	
	if(ActiveLevel.level):
		$CodingSpace.setAuthorizedInstuctions(ActiveLevel.level.authorized_logic_executions)

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
	builder.load_program(instructions)
	builder.build()
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
	
	ActiveLevel.level.build_data.building_time = builder.buildingTime
	ActiveLevel.level.build_data.grid = builder.grid.to_serializable_dict()


func _load_target():
	var result = ActiveLevel.level.build_data
	if result == null:
		push_error("No build data.")
		return

	var grid_data = result.grid
	if grid_data == null:
		push_error("No 'grid_data' found.")
		return

	var new_grid = GridResource.new()
	new_grid.load_data(grid_data)
	gridView.currentGrid = new_grid
	gridView.showTargetBlock(gridView.mode, true, Vector3i(0, 0, 0))
	
	$CodingSpace.setTip(ActiveLevel.level.tip)

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
