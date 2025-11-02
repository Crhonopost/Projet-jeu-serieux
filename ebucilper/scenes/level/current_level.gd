extends Control

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid
@onready var roundStats = $RoundStats

@export var dev_mode: bool = true                 # developpement mode

@export var level: LevelResource

signal leave

func _ready():
	_load_target()
	
	var cursor_node = $SubViewportContainer/SubViewport/Cursor
	cursor_node._set_drone_immediately(builder.cursorPosition, builder.cursorOrientation, 0.5)
	builder.block_placed.connect(cursor_node.place_block)
	builder.cursor_moved.connect(cursor_node.move_to)
	cursor_node.block_placed.connect(gridView._on_block_placed)
	cursor_node.finish_instructions.connect(func (): 
		if not builder.building: 
			gridView.placePlayerBlocs()
	)
	
	roundStats.connect("keep_playing_selected", func(): roundStats.visible = false)
	roundStats.connect("next_selected", _on_leave_pressed) 
	
	$SubViewportContainer/Menu/ModeSelector.select(gridView.mode)
	$CodingSpace.setLevel(level)

func _on_coding_space_launch(debug: bool) -> void:
	var instructions = $CodingSpace.retrieveInstructions()
	
	if(instructions.size() < level.player_instruction_count):
		level.player_instruction_count = instructions.size()
	
	#gridView.clearGrid()
	#builder.grid = gridView.currentGrid
	gridView.clear_player()
	builder.grid = gridView.playerGrid
	gridView.playerGrid.gridScale = gridView.currentGrid.gridScale
	gridView.playerGrid.clear()
	
	builder.resetState()
	# wait for the cursor back to start
	builder.load_program(instructions)
	if not debug:
		builder.build()
		print("building time :",builder.buildingTime)
		print("instructions size :",instructions)
		if(builder.buildingTime < level.player_steps):
			level.player_steps = builder.buildingTime
	else:
		$SubViewportContainer/Menu/Debug.visible = true
		
	_load_target()
	
	
	
func _unhandled_input(event: InputEvent) -> void:
	if dev_mode and event.is_action_pressed("dev_save_target"):
		_save_current_as_target()
		
func _save_current_as_target() -> void:
	if builder.grid == null:
		push_error("No grid to save.")
		return
	
	level.build_data.building_time = builder.buildingTime
	level.build_data.grid = builder.grid.to_serializable_dict()
	
	ResourceSaver.save(level)


func _load_target():
	var result = level.build_data
	if result == null:
		push_error("No build data.")
		return

	var grid_data = result.grid
	if grid_data == null:
		push_error("No 'grid_data' found.")
		return

	var new_grid = GridResource.new()
	new_grid.load_data(grid_data)
	gridView.clearGrid()
	gridView.currentGrid = new_grid
	gridView.showTargetBlock(gridView.mode, true, Vector3i(0, 0, 0))
	
	$CodingSpace.setTip(level.tip)
	$CodingSpace.setAuthorizedInstuctions(level.authorized_logic_executions)

var mouse_over_viewport = false

func _input(event: InputEvent) -> void:
	if(event.is_action("move_camera")):
		$SubViewportContainer/SubViewport/Env/CameraTarget/OrbitCamera.follow_mouse = mouse_over_viewport && event.is_action_pressed("move_camera")
	

func _on_sub_viewport_container_mouse_entered() -> void:
	mouse_over_viewport = true


func _on_sub_viewport_container_mouse_exited() -> void:
	mouse_over_viewport = false


func _on_grid_level_complete() -> void:
	level.done = true
	if OS.has_feature("build"):
		ResourceSaver.save(level)
	roundStats.visible = true
	roundStats.load_level(level)
	
	gridView.placeBlocs(builder.grid, false)
	gridView.showTargetBlock(gridView.mode, true, Vector3i.ZERO)


func _on_leave_pressed() -> void:
	leave.emit()


func _on_mode_selector_mode_selected(id: int) -> void:
	gridView.mode = id



func _on_next_pressed() -> void:
	builder.next_step()
	if(not builder.building):
		if(builder.buildingTime < level.player_steps):
			level.player_steps = builder.buildingTime
		gridView.placePlayerBlocs()
		$SubViewportContainer/Menu/Debug.visible = false


func _on_finish_pressed() -> void:
	var end = false
	while(not end):
		builder.next_step()
		end = not builder.building
	if(builder.buildingTime < level.player_steps):
		level.player_steps = builder.buildingTime
	$SubViewportContainer/Menu/Debug.visible = false
