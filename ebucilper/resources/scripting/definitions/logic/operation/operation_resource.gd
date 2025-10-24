class_name OperationResource extends ExpressionResource


enum OperatorEnum {ADD, SUB, MULT, DIV, MOD, SUPE, INFE, EQUA, NONE}

@export var variableName: String

@export var variableA: ExpressionResource
@export var operator: OperatorEnum
@export var variableB: ExpressionResource

func _to_string() -> String:
	return variableA.to_string() + " " + str(operator) + " " + variableB.to_string()

func getInstructions(parentVarName: String = "temp") -> Array[Instruction]:
	var res: Array[Instruction];
	
	var resA
	if(variableA is OperationResource):
		resA = parentVarName + "1"
		res.append_array(variableA.getInstructions(resA))
	elif(variableA is VariableExpressionResource):
		resA = variableA.value
	
	var resB
	if(variableB is OperationResource):
		resB = parentVarName + "2"
		res.append(variableB.getInstructions(resB))
	elif(variableB is VariableExpressionResource):
		resB = variableB.value
	
	var operationInstruction := UpdateVarInstruction.new()
	operationInstruction.expression.A = resA
	operationInstruction.expression.B = resB
	operationInstruction.expression.operator = operator
	
	if(variableName == ""):
		var creationInstruction := CreateVarInstruction.new()
		creationInstruction.expression.A = 0
		creationInstruction.expression.operator = OperatorEnum.NONE
		creationInstruction.target = parentVarName
		
		res.append(creationInstruction)
		operationInstruction.target = parentVarName
	else:
		operationInstruction.target = variableName
	
	res.append(operationInstruction)
	return res
