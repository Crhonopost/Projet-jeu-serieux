class_name CallFunctionLogicResource extends ExecutionLogicResource

@export var targetFunction: FunctionLogicResource
@export var args: PackedStringArray


func getName() -> String:
	return "CALL_FUNCTION"
