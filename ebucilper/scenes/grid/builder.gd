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
var instructionIdx: int # current instruction
var buildingTime: int # number of executed instructions
var runtimeVariables: Dictionary

func _ready() -> void:
	resetState()

func resetState() -> void:
	cursorOrientation = OrientationsEnum.Z_POSITIVE
	cursorPosition = Vector3i.ZERO
	currentColor = ColorsEnum.RED
	instructionIdx = 0
	runtimeVariables.clear()

func build(instructions : Array[Instruction]) -> bool:
	buildingTime = 0
	while instructionIdx<instructions.size():
		var instruction := instructions[instructionIdx]
		instructionIdx += 1
		var result = followInstruction(instruction)
		if !result: return false
	return true
	
func followInstruction(instruction : Instruction) -> bool:
	var instructionResult: bool = true
	match instruction.action:
		InstructionType.PLACE_BLOCK:
			instructionResult = placeBlock()
			buildingTime += 1
		InstructionType.MOVE_FORWARD:
			moveForward()
			buildingTime += 1
		InstructionType.MOVE_UP:
			moveUp()
			buildingTime += 1
		InstructionType.MOVE_DOWN:
			moveDown()
			buildingTime += 1
		InstructionType.ROTATE_LEFT:
			rotateLeft()
			buildingTime += 1
		InstructionType.ROTATE_RIGHT:
			rotateRight()
			buildingTime += 1
		InstructionType.CHANGE_COLOR:
			changeColor(instruction.arguments["color"])
			buildingTime += 1
		InstructionType.JUMP:
			jump(instruction.arguments["jump_index"])
		InstructionType.JUMP_IF:
			jumpIf(instruction.arguments["jump_index"], instruction.arguments["variable_a"], instruction.arguments["variable_b"], instruction.arguments["comparator"], false)
		InstructionType.JUMP_IF_NOT:
			jumpIf(instruction.arguments["jump_index"], instruction.arguments["variable_a"], instruction.arguments["variable_b"], instruction.arguments["comparator"], true)
		InstructionType.CREATE_VAR:
			createVariable(instruction.arguments["name"], instruction.arguments["value"])
		InstructionType.UPDATE_VAR:
			updateVariable(instruction.arguments["variable_name"], instruction.arguments["operation"])
		_:
			printerr("Unknown instruction type")
			instructionResult = false
	
	return instructionResult

func placeBlock():
	return grid.placeBlock(cursorPosition, currentColor)

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
	
func changeColor(color: int):
	var colorString = ColorsEnum.keys()[color]
	currentColor = ColorsEnum[colorString]

func jump(idx: int):
	instructionIdx = idx

func extractVar(variable) -> Variant:
	if variable == null: 
		return 0
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

func executeCalcul(operation: Dictionary):
	var a = extractVar(operation["operand_1"])
	var b = extractVar(operation["operand_2"])
	match operation["operator"]:
		Instruction.Operators.ADD:
			return a + b
		Instruction.Operators.SUB:
			return a - b
		Instruction.Operators.MULT:
			return a * b

func createVariable(name: String, initialValue: Variant):
	runtimeVariables[name] = extractVar(initialValue)

func updateVariable(name: String, operations: Dictionary):
	if(!runtimeVariables.has(name)): return false
	runtimeVariables[name] = executeCalcul(operations)
