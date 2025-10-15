class_name ExecutionLogicResource extends LogicResource

const InstructionType = Instruction.InstructionType
var INSTRUCTION_NAMES = {
	InstructionType.PLACE_BLOCK: "PLACE_BLOCK",
	InstructionType.MOVE_FORWARD: "MOVE_FORWARD",
	InstructionType.MOVE_UP: "MOVE_UP",
	InstructionType.MOVE_DOWN: "MOVE_DOWN",
	InstructionType.ROTATE_LEFT: "ROTATE_LEFT",
	InstructionType.ROTATE_RIGHT: "ROTATE_RIGHT",
	InstructionType.CREATE_VAR: "CREATE_VARIABLE",
	InstructionType.UPDATE_VAR: "UPDATE_VARIABLE",
	InstructionType.CHANGE_COLOR: "CHANGE_COLOR",
}

@export var type: InstructionType
@export var arguments: Dictionary

func getName() -> String:
	return INSTRUCTION_NAMES[type]
