class_name GridResource extends Resource

@export var gridScale : int = 10

var dimensions: Vector3i = Vector3i(gridScale,gridScale,gridScale)

const ColorsEnum = Global.ColorsEnum

var grid: Array[ColorsEnum]

func _init() -> void:
	grid.resize(gridScale * gridScale * gridScale)
	grid.fill(ColorsEnum.NONE)

func placeBlock(position: Vector3i, color : ColorsEnum) -> bool :
	if position.x >= gridScale or position.y >= gridScale or position.z >= gridScale:
		return false
	var index = positionToIndex(position)
	grid[index] = color
	return true

func positionToIndex(position: Vector3i) -> int :
	return position.x + position.y * gridScale + position.z * gridScale * gridScale

func clear() -> void:
	grid.fill(ColorsEnum.NONE)
