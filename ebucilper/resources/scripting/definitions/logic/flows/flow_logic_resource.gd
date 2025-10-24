class_name FlowLogicResource extends ListLogicResource

@export var condition: String
#@export var condition: ExpressionResource

func getName() -> String:
	return "If"
