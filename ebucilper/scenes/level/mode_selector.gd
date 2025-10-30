extends Control
# in inspector, set the grid_viewer_path as the node of GridViewer
@export var grid_viewer_path: NodePath
@onready var gv = get_node(grid_viewer_path)
@onready var opt: OptionButton = $modeOpt

const MODE_ALL := 0
const MODE_LAYER := 1

func _ready():
	opt.clear()
	opt.add_item("All", MODE_ALL)
	opt.add_item("Layer", MODE_LAYER)
	opt.select(int(gv.mode))
	opt.item_selected.connect(_on_item_selected)

func _on_item_selected(id:int) -> void:
	gv.mode = id
