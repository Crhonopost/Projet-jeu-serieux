class_name CreateLogicResource extends ExecutionLogicResource

@export var name := VariableExpressionResource.new()
@export var value: int


func getName() -> String:
	return "CREATE_VARIABLE"
