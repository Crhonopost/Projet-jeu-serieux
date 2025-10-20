class_name NoArgsLogicResource extends ExecutionLogicResource

@export var type: InstructionType

const InstructionType = NoArgsInstruction.NoArgInstructionType
var INSTRUCTION_NAMES = {
	InstructionType.PLACE_BLOCK: "PLACE_BLOCK",
	InstructionType.MOVE_FORWARD: "MOVE_FORWARD",
	InstructionType.MOVE_UP: "MOVE_UP",
	InstructionType.MOVE_DOWN: "MOVE_DOWN",
	InstructionType.ROTATE_LEFT: "ROTATE_LEFT",
	InstructionType.ROTATE_RIGHT: "ROTATE_RIGHT",
}

func getName()->String:
	return INSTRUCTION_NAMES[type]
