extends Node



@export var currentGrid : GridResource
enum showTargetBlockMode {all,layer,smaller}
@export var mode : showTargetBlockMode
var playerGrid: GridResource = GridResource.new() 


# func _ready() -> void:
	# fillgrid(gridTarget,0.05)
	# fillgrid(gridEditor,0.05)
	# placeBlocs(gridTarget,true)
	# placeBlocs(gridEditor, false)
func _ready():
	showTargetBlock(mode, true, Vector3i(0,0,0))

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
		
func showTargetBlock(showMode : showTargetBlockMode , show : bool, cursor_position:Vector3i):

	if not show or currentGrid == null:
		push_warning("showTargetBlock: currentGrid is null or show is false")
		return
	#$Visualization.clear()
	
	print("showTargetBlock: using gridScale = ", currentGrid.gridScale)
	print("showTargetBlock: grid size = ", currentGrid.grid.size())
	
	var S := currentGrid.gridScale

	if showMode == showTargetBlockMode.all:
		for i in range(S):
			for k in range(S):
				for j in range(S):
					var idx := i + k * S + j * S * S
					var c := currentGrid.grid[idx]
					if c != 0:
						$Visualization.instantiate(Vector3(i, k, j), c, true)

	if showMode == showTargetBlockMode.layer:
		var k := clampi(cursor_position.y, 0, S - 1)
		for i in range(S):
			for j in range(S):
				var idx := i + k * S + j * S * S
				var c := currentGrid.grid[idx]
				if c != 0:
					$Visualization.instantiate(Vector3(i, k, j), c, true)
