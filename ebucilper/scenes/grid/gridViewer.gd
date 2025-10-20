extends Node



@export var currentGrid : GridResource
enum showTargetBlockMode {all,layer,smaller}
@export var mode : showTargetBlockMode


# func _ready() -> void:
	# fillgrid(gridTarget,0.05)
	# fillgrid(gridEditor,0.05)
	# placeBlocs(gridTarget,true)
	# placeBlocs(gridEditor, false)
func _ready():
	showTargetBlock(mode, true, Vector3i(1,2,3))

func clearGrid():
	currentGrid.clear()
	$Visualization.clear()


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
		return

	if showMode == showTargetBlockMode.all:
		for i in range (currentGrid.gridScale) :
			for j in range (currentGrid.gridScale) :
				for k in range (currentGrid.gridScale) :
					$Visualization.instantiate(Vector3(i, k, j), Global.ColorsEnum.RED, true)
	if showMode == showTargetBlockMode.layer:
		var layer_pos = cursor_position.y
		for i in range (currentGrid.gridScale) :
			for j in range (currentGrid.gridScale) :
				$Visualization.instantiate(Vector3(i, layer_pos, j), Global.ColorsEnum.RED, true)
