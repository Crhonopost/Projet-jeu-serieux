class_name SetCursorPositionLogicResource extends ExecutionLogicResource

@export var position_x : String
@export var position_y : String
@export var position_z : String

func getName() -> String:
	return "SET_CURSOR_POSITION"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/Set_position.png")
