extends Control

@export var variable : VariableResource

func _ready() -> void:
	variable.connect("valueChanged", onValueChanged)
	$Name.text = str(variable.value)

func onValueChanged(newValue):
	$Name.text = str(newValue)

func _get_drag_data(at_position: Vector2) -> Variant:
	var visu = $Name.duplicate()
	set_drag_preview(visu)
	return variable
