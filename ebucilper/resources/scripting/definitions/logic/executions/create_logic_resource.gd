class_name CreateLogicResource extends ExecutionLogicResource

@export var name : String
@export var value: String

#@export var name := VariableExpressionResource.new()
#@export var value: int


func getName() -> String:
	return "CREATE_VARIABLE"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/Move_up.png")
