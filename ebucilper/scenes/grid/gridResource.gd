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
	
func to_serializable_dict() -> Dictionary:
	var dims := [gridScale, gridScale, gridScale]

	var grid_copy := grid.duplicate(true)

	return {
		"dimensions": dims,
		"grid": grid_copy
	}
	

func from_serializable_dict(data: Dictionary) -> void:
	if not data.has("dimensions") or not data.has("grid"):
		push_error("Invalid grid data: missing keys.")
		return
		
	var dims = data["dimensions"]
	if dims.size() != 3:
		push_error("Invalid grid dimensions.")
		return
	
	gridScale = int(dims[0])
	grid.resize(gridScale * gridScale * gridScale)

	var grid_data = data["grid"]
	print("Loading grid of size: ", grid_data.size())

	for i in range(min(grid.size(), grid_data.size())):
		grid[i] = int(grid_data[i])
