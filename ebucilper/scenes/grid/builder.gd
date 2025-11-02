extends Node3D
@onready var grid_view := $"../Grid"

const NoArgInstructionType = NoArgsInstruction.NoArgInstructionType
const ColorsEnum = Global.ColorsEnum
const OrientationsEnum = Global.OrientationsEnum

var grid : GridResource

var rightOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_POSITIVE, OrientationsEnum.Z_NEGATIVE, OrientationsEnum.X_NEGATIVE, OrientationsEnum.X_POSITIVE]
var leftOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_NEGATIVE, OrientationsEnum.Z_POSITIVE, OrientationsEnum.X_POSITIVE, OrientationsEnum.X_NEGATIVE]

var cursorOrientation: OrientationsEnum
var cursorPosition: Vector3i
var currentColor: ColorsEnum
var buildingTime: int # number of executed instructions
var building: bool

signal cursor_moved(pos: Vector3i, orientation: OrientationsEnum)
signal block_placed(pos: Vector3i, color: int)


var callStack : Array[ExecutionContext]

func _ready() -> void:
	resetState()

func resetState() -> void:
	cursorOrientation = OrientationsEnum.Z_POSITIVE
	cursorPosition = Vector3i.ZERO
	currentColor = ColorsEnum.RED
	callStack.clear()
	emit_signal("cursor_moved", cursorPosition, cursorOrientation)


var instructionList: Array[Instruction]
func load_program(instructions: Array[Instruction]):
	instructionList = instructions
	buildingTime = 0
	
	var init := ExecutionContext.new()
	init.instructionIdx = 0
	callStack.append(init)

func next_step():
	var instruction := instructionList[callStack.back().instructionIdx]
	callStack.back().instructionIdx += 1
	building = followInstruction(instruction) && callStack.size() > 0

func build() -> bool:
	while callStack.size() > 0:
		next_step()
		if not building:
			return false
	building = false
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
		NoArgInstructionType.EXIT_FUNCTION:
			callStack.pop_back()
	
	return instructionResult

func followInstruction(instruction : Instruction) -> bool:
	var instructionResult: bool = true
	if instruction is NoArgsInstruction:
		instructionResult = followNoArgs(instruction)
	elif instruction is ChangeColorInstruction:
		changeColor(instruction.color)
	elif instruction is JumpToIfInstruction:
		jumpIf(instruction.toIdx, instruction.condition, instruction.evaluateNot)
	elif instruction is JumpToInstruction:
		jump(instruction.toIdx)
	elif instruction is CreateVarInstruction:
		createVariable(instruction.target, instruction.expression)
	elif instruction is UpdateVarInstruction:
		updateVariable(instruction.target, instruction.expression)
	elif instruction is CallFunctionInstruction:
		callFunction(instruction.jumpIdx, instruction.argsToVar)
	elif instruction is SetCursorPositionInstruction:
		moveTo(instruction.position_x, instruction.position_y, instruction.position_z)
	else:
		printerr("Unknown instruction type")
		instructionResult = false
	
	return instructionResult

func placeBlock():
	var ok := grid.placeBlock(cursorPosition, currentColor)
	if ok:
		call_deferred("emit_signal", "block_placed", cursorPosition, currentColor)
	else:
		push_warning("placeBlock failed at %s" % [cursorPosition])
	buildingTime += 1
	return ok


func moveTo(position_x: LowLevelExpression, position_y: LowLevelExpression, position_z: LowLevelExpression):
	var cur_variables = callStack.back().variables
	cursorPosition = Vector3i(
		position_x.execute(cur_variables),
		position_y.execute(cur_variables),
		position_z.execute(cur_variables)
	)
	if grid_view and grid_view.has_method("move_to_start"):
		grid_view.move_to_start(cursorPosition, cursorOrientation)
	else:
		buildingTime += 1
		call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)

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
	buildingTime += 1
	call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)

func moveUp():
	cursorPosition.y += 1
	buildingTime += 1
	call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)
	
func moveDown():
	cursorPosition.y -= 1
	buildingTime += 1
	call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)

func rotateLeft():
	cursorOrientation = leftOrientation[cursorOrientation]
	buildingTime += 1
	call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)
	
func rotateRight():
	cursorOrientation = rightOrientation[cursorOrientation]
	buildingTime += 1
	call_deferred("emit_signal", "cursor_moved", cursorPosition, cursorOrientation)
	
func changeColor(color: int):
	var colorString = ColorsEnum.keys()[color]
	buildingTime += 1
	currentColor = ColorsEnum[colorString]

func jump(idx: int):
	callStack.back().instructionIdx = idx

func extractVar(variable) -> Variant:
	if variable == null: 
		return 0
	if variable is String:
		return callStack.back().variables[variable]
	elif variable is not float && variable is not int && variable is not bool:
		return 0
	else:
		return variable

func jumpIf(idx: int, expression: LowLevelExpression, negation: bool):
	var comparison: bool = expression.execute(callStack.back().variables)
	
	if( (negation && !comparison) || 
		(!negation && comparison)):
		callStack.back().instructionIdx = idx

func createVariable(name: String, initialValue: LowLevelExpression):
	callStack.back().variables[name] = initialValue.execute(callStack.back().variables)

func updateVariable(name: String, expression: LowLevelExpression):
	if(!callStack.back().variables.has(name)): return false
	callStack.back().variables[name] = expression.execute(callStack.back().variables)

func callFunction(idx: int, argsToVar: Dictionary[String, LowLevelExpression]):
	var initVariables: Dictionary[String, int]
	for arg in argsToVar.keys():
		initVariables[arg] = argsToVar[arg].execute(callStack.back().variables)
	
	startFunction()
	callStack.back().instructionIdx = idx
	callStack.back().variables = initVariables

func startFunction():
	var context = ExecutionContext.new()
	context.instructionIdx = callStack.back().instructionIdx
	callStack.push_back(context)
	return

func endFunction():
	callStack.pop_back()
