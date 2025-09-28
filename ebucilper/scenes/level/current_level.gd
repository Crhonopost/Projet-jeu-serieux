extends Control

@onready var builder = $SubViewportContainer/SubViewport/Builder

func _on_coding_space_launch() -> void:
	var instructions = $CodingSpace.retrieveInstructions()
	builder.grid = $SubViewportContainer/SubViewport/Grid.gridEditor
	builder.build(instructions)
	$SubViewportContainer/SubViewport/Grid.placeBlocs(builder.grid, false)
