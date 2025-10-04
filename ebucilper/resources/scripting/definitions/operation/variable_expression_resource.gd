class_name VariableExpressionResource extends ExpressionResource

@export var value: Variant

signal valueChanged(newValue: Variant)

func evaluate() -> float:
	return value
	
func getInstructions(parentVarName: String = "temp") -> Array[Instruction]:
	return []


func setValue(newValue):
	value = newValue
	emit_signal("valueChanged", newValue)

func _init() -> void:
	if(value == null):
		value = 0

func _to_string() -> String:
	return str(value)
