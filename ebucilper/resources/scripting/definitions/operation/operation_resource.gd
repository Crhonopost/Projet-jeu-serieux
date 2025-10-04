class_name OperationResource extends ExpressionResource


@export var variableName: String

@export var variableA: ExpressionResource
@export var operator: Instruction.Operators
@export var variableB: ExpressionResource

func _to_string() -> String:
	return variableA.to_string() + " " + str(operator) + " " + variableB.to_string()

func getInstructions(parentVarName: String = "temp") -> Array[Instruction]:
	var res: Array[Instruction];
	
	var resA
	if(variableA is OperationResource):
		resA = parentVarName + "1"
		res.append(variableA.getInstructions(resA))
	elif(variableA is VariableExpressionResource):
		resA = variableA.variable.value
	
	var resB
	if(variableB is OperationResource):
		resB = parentVarName + "2"
		res.append(variableB.getInstructions(resB))
	elif(variableB is VariableExpressionResource):
		resB = variableB.variable.value
	
	var operationInstruction := Instruction.new()
	operationInstruction.action = Instruction.InstructionType.UPDATE_VAR
	operationInstruction.arguments["operation"] = {
		"operand_1" : resA,
		"operand_2" : resB,
		"operator" : operator
	}
	operationInstruction.arguments["variable_name"] = variableName if variableName != "" else parentVarName
	
	res.append_array(resA)
	res.append_array(resB)
	res.append(operationInstruction)
	return res
