extends Control

@export var variableResource: VariableResource

signal picked

func _get_drag_data(at_position: Vector2) -> Variant:
	var label := Label.new()
	label.text = variableResource.name
	set_drag_preview(label)
	emit_signal("picked")
	return variableResource
