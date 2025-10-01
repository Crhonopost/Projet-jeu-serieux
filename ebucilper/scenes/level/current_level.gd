extends Control

@onready var builder = $SubViewportContainer/SubViewport/Builder
@onready var gridView = $SubViewportContainer/SubViewport/Grid

func _on_coding_space_launch() -> void:
	var instructions = $CodingSpace.retrieveInstructions()
	gridView.clearGrid()
	builder.grid = gridView.currentGrid
	builder.resetState()
	builder.build(instructions)
	gridView.placeBlocs(builder.grid, false)
