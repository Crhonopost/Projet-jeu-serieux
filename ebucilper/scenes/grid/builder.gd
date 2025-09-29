extends Node3D

const InstructionType = Instruction.InstructionType
const ColorsEnum = Global.ColorsEnum

var grid : GridResource

enum OrientationsEnum  { X_POSITIVE=0, X_NEGATIVE=1, Z_POSITIVE=2, Z_NEGATIVE=3 }
var rightOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_POSITIVE, OrientationsEnum.Z_NEGATIVE, OrientationsEnum.X_NEGATIVE, OrientationsEnum.X_POSITIVE]
var leftOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_NEGATIVE, OrientationsEnum.Z_POSITIVE, OrientationsEnum.X_POSITIVE, OrientationsEnum.X_NEGATIVE]

var cursorOrientation: OrientationsEnum
var cursorPosition: Vector3i
var currentColor: ColorsEnum
var instructionIdx: int
var buildingTime: int
var runtimeVariables: Dictionary

func _ready() -> void:
	resetState()

func resetState() -> void:
	cursorOrientation = OrientationsEnum.Z_POSITIVE
	cursorPosition = Vector3i.ZERO
	currentColor = ColorsEnum.RED
	instructionIdx = 0
	runtimeVariables.clear()
	runtimeVariables["test"] = 0

func build(instructions : Array[Instruction]) -> bool:
	buildingTime = instructions.size()
	while instructionIdx<instructions.size():
		var instruction := instructions[instructionIdx]
		instructionIdx += 1
		var result = followInstruction(instruction)
		if !result: return false
		runtimeVariables["test"] += 1
	return true
	
func followInstruction(instruction : Instruction) -> bool:
	var instructionResult: bool = true
	match instruction.action:
		InstructionType.PLACE_BLOCK:
			placeBlock()
		InstructionType.MOVE_FORWARD:
			moveForward()
		InstructionType.MOVE_UP:
			moveUp()
		InstructionType.MOVE_DOWN:
			moveDown()
		InstructionType.ROTATE_LEFT:
			rotateLeft()
		InstructionType.ROTATE_RIGHT:
			rotateRight()
		InstructionType.CHANGE_COLOR:
			changeColor(instruction.arguments["color"])
		InstructionType.JUMP:
			jump(instruction.arguments["jump_index"])
		InstructionType.JUMP_IF:
			jumpIf(instruction.arguments["jump_index"], instruction.arguments["variable_a"], instruction.arguments["variable_b"], instruction.arguments["comparator"], false)
		InstructionType.JUMP_IF_NOT:
			jumpIf(instruction.arguments["jump_index"], instruction.arguments["variable_a"], instruction.arguments["variable_b"], instruction.arguments["comparator"], true)
		_:
			printerr("Unknown instruction type")
			instructionResult = false
	return instructionResult

func placeBlock():
	grid.placeBlock(cursorPosition, currentColor)

func moveForward():
	var vec = Vector3i(0,0,0)
	if(cursorOrientation == OrientationsEnum.X_POSITIVE):
		vec += Vector3i(1,0,0)
	elif(cursorOrientation == OrientationsEnum.X_NEGATIVE):
		vec -= Vector3i(1,0,0)
	elif(cursorOrientation == OrientationsEnum.Z_POSITIVE):
		vec += Vector3i(0,0,1)
	elif(cursorOrientation == OrientationsEnum.Z_NEGATIVE):
		vec -= Vector3i(0,0,1)
	cursorPosition += vec

func moveUp():
	cursorPosition.y += 1
	
func moveDown():
	cursorPosition.y -= 1

func rotateLeft():
	cursorOrientation = leftOrientation[cursorOrientation]
	
func rotateRight():
	cursorOrientation = rightOrientation[cursorOrientation]
	
func changeColor(color: String):
	currentColor = ColorsEnum[color]

func jump(idx: int):
	instructionIdx = idx

func extractVar(variable) -> Variant:
	if variable is String:
		return runtimeVariables[variable]
	else:
		return variable

func jumpIf(idx: int, variableA: Variant, variableB: Variant, comparator: Instruction.Comparators, negation: bool):
	var varA = extractVar(variableA)
	var varB = extractVar(variableB)
	
	var comparison: bool
	match comparator:
		Instruction.Comparators.SUPERIOR:
			comparison = varA > varB
		Instruction.Comparators.INFERIOR:
			comparison = varA < varB
		Instruction.Comparators.EQUAL:
			comparison = varA == varB
	
	if( (negation && !comparison) || 
		(!negation && comparison)):
		instructionIdx = idx
	
