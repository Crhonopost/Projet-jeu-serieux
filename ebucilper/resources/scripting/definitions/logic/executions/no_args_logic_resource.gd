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

var INSTRUCTION_LOGOS = {
	InstructionType.PLACE_BLOCK: preload("res://Assets/Images/code/Logos/Place_block.png"),
	InstructionType.MOVE_FORWARD: preload("res://Assets/Images/code/Logos/Move_forward.png"),
	InstructionType.MOVE_UP: preload("res://Assets/Images/code/Logos/Move_up.png"),
	InstructionType.MOVE_DOWN: preload("res://Assets/Images/code/Logos/Move_down.png"),
	InstructionType.ROTATE_LEFT: preload("res://Assets/Images/code/Logos/Turn_left.png"),
	InstructionType.ROTATE_RIGHT: preload("res://Assets/Images/code/Logos/Turn_right.png"),
}

func getName()->String:
	return INSTRUCTION_NAMES[type]

func getLogo() -> Texture2D:
	return INSTRUCTION_LOGOS[type]
