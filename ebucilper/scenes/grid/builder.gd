extends Node3D

const NoArgInstructionType = NoArgsInstruction.NoArgInstructionType
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

func followNoArgs(instruction: NoArgsInstruction) -> bool:
	var instructionResult: bool = true
	match instruction.action:
		NoArgInstructionType.PLACE_BLOCK:
			instructionResult = placeBlock()
		NoArgInstructionType.MOVE_FORWARD:
			moveForward()
		NoArgInstructionType.MOVE_UP:
			moveUp()
		NoArgInstructionType.MOVE_DOWN:
			moveDown()
		NoArgInstructionType.ROTATE_LEFT:
			rotateLeft()
		NoArgInstructionType.ROTATE_RIGHT:
			rotateRight()
	
	buildingTime += 1
	return instructionResult

func followInstruction(instruction : Instruction) -> bool:
	var instructionResult: bool = true
	if instruction is NoArgsInstruction:
		followNoArgs(instruction)
	elif instruction is ChangeColorInstruction:
		changeColor(instruction.color)
		buildingTime += 1
	elif instruction is JumpToIfInstruction:
		jumpIf(instruction.toIdx, instruction.condition, instruction.evaluateNot)
	elif instruction is JumpToInstruction:
		jump(instruction.toIdx)
	elif instruction is CreateVarInstruction:
		createVariable(instruction.target, instruction.expression)
	elif instruction is UpdateVarInstruction:
		updateVariable(instruction.target, instruction.expression)
	else:
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
	elif variable is not float && variable is not int && variable is not bool:
		return 0
	else:
		return variable

func jumpIf(idx: int, expression: LowLevelExpression, negation: bool):
	var varA = extractVar(expression.A)
	var varB = extractVar(expression.B)
	
	var comparison: bool = expression.execute(varA, expression.operator, varB)
	
	if( (negation && !comparison) || 
		(!negation && comparison)):
		instructionIdx = idx

func executeCalcul(expression: LowLevelExpression) -> int:
	var varA = extractVar(expression.A)
	
	if expression.operator == LowLevelExpression.OperatorEnum.NONE:
		return varA
	
	var varB = extractVar(expression.B)
	return expression.execute(varA, expression.operator, varB)

func createVariable(name: String, initialValue: LowLevelExpression):
	runtimeVariables[name] = executeCalcul(initialValue)

func updateVariable(name: String, expression: LowLevelExpression):
	if(!runtimeVariables.has(name)): return false
	runtimeVariables[name] = executeCalcul(expression)
