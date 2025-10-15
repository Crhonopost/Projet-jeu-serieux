class_name VariableExpressionResource extends ExpressionResource

@export var value: Variant

signal valueChanged(newValue: Variant)

func evaluate() -> float:
	return value
	
func getInstructions(parentVarName: String = "temp") -> Array[Instruction]:
	var resInstru = Instruction.new()
	resInstru.action = Instruction.InstructionType.UPDATE_VAR
	resInstru.arguments["variable_name"] = parentVarName
	resInstru.arguments["operation"] = {
		"operand_1" : 0,
		"operand_2" : value,
		"operator" : Instruction.Operators.ADD
	}
	return [resInstru]


func setValue(newValue):
	value = newValue
	emit_signal("valueChanged", newValue)

func _init() -> void:
	if(value == null):
		value = 0

func _to_string() -> String:
	return str(value)
