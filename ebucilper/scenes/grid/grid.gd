extends Node3D


enum OrientationsEnum  {X_POSI=0, X_NEGA=1, Z_POSI=2, Z_NEGA=3}
enum ColorsEnum {NONE=0, RED=1, BLUE=2}

var rightOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_POSI, OrientationsEnum.Z_NEGA, OrientationsEnum.X_NEGA, OrientationsEnum.X_POSI]
var leftOrientation: Array[OrientationsEnum] = [OrientationsEnum.Z_NEGA, OrientationsEnum.Z_POSI, OrientationsEnum.X_POSI, OrientationsEnum.X_NEGA]


var cursorPosition: Vector3i
var cursorOrientation: OrientationsEnum

@export var gridScale : float = 1
var dimmensions: Vector3i = Vector3i(10,10,10)
var blocs: Array[ColorsEnum]


func _ready() -> void:
	blocs.resize(dimmensions.x * dimmensions.y * dimmensions.z)
	blocs.fill(ColorsEnum.NONE)
	
	
	placeBlock(ColorsEnum.BLUE)
	moveForward()
	moveUp()
	placeBlock(ColorsEnum.RED)
	rotateLeft()
	moveForward()
	rotateLeft()
	moveUp()
	placeBlock(ColorsEnum.BLUE)
	moveForward()
	moveUp()
	placeBlock(ColorsEnum.RED)


func posToIdx(position: Vector3i) -> int:
	return position.z + position.x * dimmensions.z + position.y * dimmensions.z * dimmensions.x

func placeBlock(color: ColorsEnum):
	var cellIndex = posToIdx(cursorPosition) 
	blocs[cellIndex] = color
	$Visualization.instantiate(Vector3(cursorPosition) * gridScale, color)

func moveForward():
	var vec = Vector3i(0,0,0)
	if(cursorOrientation == OrientationsEnum.X_POSI):
		vec += Vector3i(1,0,0)
	elif(cursorOrientation == OrientationsEnum.X_NEGA):
		vec -= Vector3i(1,0,0)
	elif(cursorOrientation == OrientationsEnum.Z_POSI):
		vec += Vector3i(0,0,1)
	elif(cursorOrientation == OrientationsEnum.Z_NEGA):
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



var commands = []
func registerForward():
	commands.append(func (): moveForward())
func registerRotateLeft():
	commands.append(func (): rotateLeft())


func clear():
	commands.clear()
	var childs = $Visualization.get_children()
	for child in childs:
		child.queue_free()

func processCommands():
	for command in commands:
		command.call()
