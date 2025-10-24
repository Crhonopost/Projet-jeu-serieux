class_name VariableExpressionResource extends ExpressionResource

@export var value: Variant

signal valueChanged(newValue: Variant)

func evaluate() -> float:
	return value
	
func getInstructions(parentVarName: String = "temp") -> Array[Instruction]:
	var resInstru = UpdateVarInstruction.new()
	resInstru.target = parentVarName
	resInstru.expression.A = value
	resInstru.expression.operator = OperationResource.OperatorEnum.NONE
	return [resInstru]


func setValue(newValue):
	value = newValue
	emit_signal("valueChanged", newValue)

func _init() -> void:
	if(value == null):
		value = 0

func _to_string() -> String:
	return str(value)
