class_name ChangeColorLogicResource extends ExecutionLogicResource

@export var color : Global.ColorsEnum

func getName() -> String:
	return "CHANGE_COLOR"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/Change_color.png")
