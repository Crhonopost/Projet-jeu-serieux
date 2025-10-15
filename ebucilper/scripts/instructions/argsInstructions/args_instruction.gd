@abstract
class_name ArgsInstruction extends Instruction


enum ArgInstructionType {JUMP_IF, JUMP_IF_NOT, CREATE_VAR, UPDATE_VAR}

func hasArg() -> bool:
	return true
