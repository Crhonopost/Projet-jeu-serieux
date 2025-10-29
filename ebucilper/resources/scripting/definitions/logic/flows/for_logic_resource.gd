class_name ForLogicResource extends ListLogicResource

@export var variableName: String
@export var stepCount: String

func getName() -> String:
	return "For"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/For.png")
