class_name ExecutionInstructionResource extends InstructionResource

const InstructionType = Instruction.InstructionType
var INSTRUCTION_NAMES = {
	InstructionType.PLACE_BLOCK: "PLACE_BLOCK",
	InstructionType.MOVE_FORWARD: "MOVE_FORWARD",
	InstructionType.MOVE_UP: "MOVE_UP",
	InstructionType.MOVE_DOWN: "MOVE_DOWN",
	InstructionType.ROTATE_LEFT: "ROTATE_LEFT",
	InstructionType.ROTATE_RIGHT: "ROTATE_RIGHT"
}

@export var type: InstructionType

func getName() -> String:
	return INSTRUCTION_NAMES[type]
