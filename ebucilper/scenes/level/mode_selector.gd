extends OptionButton
# in inspector, set the grid_viewer_path as the node of GridViewer
@export var grid_viewer_path: NodePath

const MODE_ALL := 0
const MODE_LAYER := 1
signal mode_selected(id: int)

func _ready():
	clear()
	add_item("All", MODE_ALL)
	add_item("Layer", MODE_LAYER)

func _on_item_selected(id:int) -> void:
	mode_selected.emit(id)
