extends Node


@export var gridTarget : GridResource

@export var gridEditor : GridResource



# func _ready() -> void:
	# fillgrid(gridTarget,0.05)
	# fillgrid(gridEditor,0.05)
	# placeBlocs(gridTarget,true)
	# placeBlocs(gridEditor, false)

func clearEditor():
	gridEditor.clear()
	$Visualization.clear()
	placeBlocs(gridTarget, true)

func placeBlocs(gridResource : GridResource, isTransparent : bool) :
	for i in range (gridResource.gridScale) :
		for j in range (gridResource.gridScale) :
			for k in range (gridResource.gridScale) :
				var current = gridResource.grid[i + k * gridResource.gridScale + j * gridResource.gridScale * gridResource.gridScale]
				if(current != Global.ColorsEnum.NONE):
					$Visualization.instantiate(Vector3(i,k,j),current,isTransparent);


func fillgrid(gridResource : GridResource, prob : float):
	for i in range (gridResource.grid.size()):
		var nbColor = Global.ColorsEnum.keys().size()
		var color = randi() % 2
		var x = randf()
		if(x < prob):
			if(color == 1):
				gridResource.grid[i] = Global.ColorsEnum.RED
			else :
				gridResource.grid[i] = Global.ColorsEnum.BLUE
		
