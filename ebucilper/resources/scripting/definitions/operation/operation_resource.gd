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
		resA = variableA.value
	
	var resB
	if(variableB is OperationResource):
		resB = parentVarName + "2"
		res.append(variableB.getInstructions(resB))
	elif(variableB is VariableExpressionResource):
		resB = variableB.value
	
	var operationInstruction := Instruction.new()
	operationInstruction.action = Instruction.InstructionType.UPDATE_VAR
	operationInstruction.arguments["operation"] = {
		"operand_1" : resA,
		"operand_2" : resB,
		"operator" : operator
	}
	if(variableName == ""):
		var creationInstruction := Instruction.new()
		creationInstruction.action = Instruction.InstructionType.CREATE_VAR
		creationInstruction.arguments["name"] = parentVarName
		creationInstruction.arguments["value"] = 0
		
		res.append(creationInstruction)
		operationInstruction.arguments["variable_name"] = parentVarName
	else:
		operationInstruction.arguments["variable_name"] = variableName
	
	res.append(operationInstruction)
	return res
