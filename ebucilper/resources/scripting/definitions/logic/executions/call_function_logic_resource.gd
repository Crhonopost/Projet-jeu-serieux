class_name CallFunctionLogicResource extends ExecutionLogicResource

@export var name : String
@export var args: PackedStringArray


func getName() -> String:
	return "CALL_FUNCTION"
