class_name UpdateLogicResource extends ExecutionLogicResource

@export var name := VariableExpressionResource.new()
@export var expression: ExpressionResource = VariableExpressionResource.new()

func getName() -> String:
	return "UPDATE_VARIABLE"
