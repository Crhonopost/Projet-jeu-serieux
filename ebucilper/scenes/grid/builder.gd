extends Node3D

const Instruction = Global.InstructionType
const ColorsEnum = Global.ColorsEnum

var grid : GridResource

enum OrientationsEnum  { X_POSITIVE=0, X_NEGATIVE=1, Z_POSITIVE=2, Z_NEGATIVE=3 }
var rightOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_POSITIVE, OrientationsEnum.Z_NEGATIVE, OrientationsEnum.X_NEGATIVE, OrientationsEnum.X_POSITIVE]
var leftOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_NEGATIVE, OrientationsEnum.Z_POSITIVE, OrientationsEnum.X_POSITIVE, OrientationsEnum.X_NEGATIVE]


var cursorOrientation: OrientationsEnum
var cursorPosition: Vector3i

var buildingTime: int

func _ready() -> void:
	pass

func build(instructions : Array[Instruction]) -> bool:
	buildingTime = instructions.size()
	for instruction in instructions:
		var result = followInstruction(instruction)
		if !result: return false
	return true
	
func followInstruction(instruction : Instruction) -> bool:
	var instructionResult: bool
	match instruction:
		Instruction.PLACE_BLOCK:
			pass
		Instruction.MOVE_FORWARD:
			pass
		Instruction.MOVE_UP:
			pass
		Instruction.MOVE_DOWN:
			pass
		Instruction.ROTATE_LEFT:
			pass
		Instruction.ROTATE_RIGHT:
			pass
	if !instructionResult:
		return false
	return true

func placeBlock(color: ColorsEnum):
	grid.placeBlock(cursorPosition, color)

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
