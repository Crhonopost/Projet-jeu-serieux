class_name FlowLogicResource extends ListLogicResource

@export var condition: String

func getName() -> String:
	return "If"

func getLogo() -> Texture2D:
	return load("res://Assets/Images/code/Logos/If.png")
