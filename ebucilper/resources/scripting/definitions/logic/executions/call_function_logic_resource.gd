class_name CallFunctionLogicResource extends ExecutionLogicResource

@export var targetFunction: FunctionLogicResource
@export var args: PackedStringArray


func getName() -> String:
	return "CALL_FUNCTION"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/Call_function.png")
