class_name Instruction

enum InstructionType {PLACE_BLOCK, MOVE_FORWARD, MOVE_UP, MOVE_DOWN, ROTATE_LEFT, ROTATE_RIGHT, CHANGE_COLOR, JUMP, JUMP_IF, JUMP_IF_NOT, CREATE_VAR, UPDATE_VAR}

enum Comparators {SUPERIOR, INFERIOR, EQUAL}
enum Operators {ADD, SUB, MULT}

var action: InstructionType
var arguments: Dictionary
