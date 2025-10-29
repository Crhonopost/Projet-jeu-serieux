class_name UpdateLogicResource extends ExecutionLogicResource

@export var name : String
@export var expression: String

#@export var name := VariableExpressionResource.new()
#@export var expression: ExpressionResource = VariableExpressionResource.new()

func getName() -> String:
	return "UPDATE_VARIABLE"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/Update_var.png")
