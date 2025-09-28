class_name Instruction

enum InstructionType {PLACE_BLOCK, MOVE_FORWARD, MOVE_UP, MOVE_DOWN, ROTATE_LEFT, ROTATE_RIGHT, CHANGE_COLOR}

var action: InstructionType
var arguments: Dictionary
