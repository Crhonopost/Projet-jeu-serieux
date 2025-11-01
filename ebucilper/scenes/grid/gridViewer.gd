extends Node

signal level_complete

@export var currentGrid : GridResource
enum showTargetBlockMode {all,layer,smaller}
@export var mode : showTargetBlockMode : set = set_mode
var playerGrid: GridResource = GridResource.new()
@onready var builder: Node3D = $"../Builder"

var _last_layer := -1

# func _ready() -> void:
	# fillgrid(gridTarget,0.05)
	# fillgrid(gridEditor,0.05)
	# placeBlocs(gridTarget,true)
	# placeBlocs(gridEditor, false)
func _ready():
	clearGrid()
	
	builder.grid = playerGrid

	
func _process(_dt):
	if mode == showTargetBlockMode.layer and currentGrid != null and builder != null:
		var S := currentGrid.gridScale
		var k := clampi(builder.cursorPosition.y, 0, S - 1)
		if k != _last_layer:
			if $Visualization.has_method("clear_target"):
				$Visualization.clear_target()
			_draw_target_layer(k)
			_last_layer = k


func _on_block_placed(pos: Vector3i, color: int) -> void:
	if $Visualization:
		$Visualization.instantiate(Vector3(pos.x, pos.y, pos.z), color, false)
		$Sounds.place_block()

func set_mode(v:int) -> void:
	if mode == v:
		return
	mode = v
	if $Visualization.has_method("clear_target"):
		$Visualization.clear_target()
	match mode:
		showTargetBlockMode.all:
			showTargetBlock(showTargetBlockMode.all, true, builder.cursorPosition)
		showTargetBlockMode.layer:
			_last_layer = -1

func clearGrid():
	currentGrid.clear()
	$Visualization.clear()
	
func clear_player():
	$Visualization.clear()


func placePlayerBlocs() -> void:
	var S := playerGrid.gridScale
	for i in range(S):
		for k in range(S):
			for j in range(S):
				var idx := i + k * S + j * S * S
				var c := playerGrid.grid[idx]
				if c != Global.ColorsEnum.NONE:
					$Visualization.instantiate(Vector3(i, k, j), c, false)
	_on_current_level_check_grid()


func placeBlocs(gridResource : GridResource, isTransparent : bool) :
	for i in range (gridResource.gridScale) :
		for j in range (gridResource.gridScale) :
			for k in range (gridResource.gridScale) :
				var current = gridResource.grid[i + k * gridResource.gridScale + j * gridResource.gridScale * gridResource.gridScale]
				if(current != Global.ColorsEnum.NONE):
					$Visualization.instantiate(Vector3(i,k,j),current,isTransparent);


func fillgrid(gridResource : GridResource, prob : float):
	for i in range (gridResource.grid.size()):
		gridResource.grid[i] = Global.ColorsEnum.RED

		
		
func _draw_target_layer(k:int) -> void:
	var S := currentGrid.gridScale
	for i in range(S):
		for j in range(S):
			var idx := i + k * S + j * S * S
			var c := currentGrid.grid[idx]
			if c != 0:
				$Visualization.instantiate(Vector3(i, k, j), c, true)
				

		
func showTargetBlock(showMode : showTargetBlockMode , show : bool, cursor_position:Vector3i):

	if not show or currentGrid == null:
		push_warning("showTargetBlock: currentGrid is null or show is false")
		return
	#$Visualization.clear()
	
	var S := currentGrid.gridScale

	if showMode == showTargetBlockMode.all:
		for i in range(S):
			for k in range(S):
				for j in range(S):
					var idx := i + k * S + j * S * S
					var c := currentGrid.grid[idx]
					if c != 0:
						$Visualization.instantiate(Vector3(i, k, j), c, true)

	elif showMode == showTargetBlockMode.layer:
		_draw_target_layer(clampi(cursor_position.y, 0, S - 1))
		

func _grids_are_equal(grid1: GridResource, grid2: GridResource) -> bool:
	
	if grid1.gridScale != grid2.gridScale:
		
		return false

	for i in range(grid1.grid.size()):
		if grid1.grid[i] != grid2.grid[i]:
			print("current :",grid1.grid[i],"\t player:", grid2.grid[i],"\tindice :", i)
			return false

	return true

func _on_current_level_check_grid() -> void:
	if _grids_are_equal(currentGrid, playerGrid):
		print("level complete")
		level_complete.emit()


func _on_current_level_next_grid_tutorial(grid) -> void:
	clearGrid()
	currentGrid = grid
