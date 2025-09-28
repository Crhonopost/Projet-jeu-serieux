extends Node

enum ColorsEnum {NONE=0, RED=1, BLUE=2}

enum InstructionType {PLACE_BLOCK, MOVE_FORWARD, MOVE_UP, MOVE_DOWN, ROTATE_LEFT, ROTATE_RIGHT, CHANGE_COLOR}

#var action: Instruction
#var arguments: Dictionary
