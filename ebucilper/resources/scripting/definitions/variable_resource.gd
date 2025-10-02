class_name VariableResource extends Resource

@export var value: Variant

signal valueChanged(newValue: Variant)

func setValue(newValue):
	value = newValue
	emit_signal("valueChanged", newValue)

func _init() -> void:
	if(value == null):
		value = 0
