class_name ForInstructionResource extends FlowInstructionResource

@export var iterationCount = 1


func getName() -> String:
	return "For " + str(iterationCount)
