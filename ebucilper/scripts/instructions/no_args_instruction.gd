class_name NoArgsInstruction extends Instruction

enum NoArgInstructionType { PLACE_BLOCK, MOVE_FORWARD, MOVE_UP, MOVE_DOWN, ROTATE_LEFT, ROTATE_RIGHT, EXIT_FUNCTION }
var action: NoArgInstructionType

func hasArg() -> bool:
	return false
