class_name Instruction

enum InstructionType {PLACE_BLOCK, MOVE_FORWARD, MOVE_UP, MOVE_DOWN, ROTATE_LEFT, ROTATE_RIGHT, CHANGE_COLOR, JUMP, JUMP_IF, JUMP_IF_NOT, STORE_VAR}

enum Comparators {SUPERIOR, INFERIOR, EQUAL}

var action: InstructionType
var arguments: Dictionary
