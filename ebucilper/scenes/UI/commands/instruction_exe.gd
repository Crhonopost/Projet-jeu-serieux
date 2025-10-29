extends Control

@export var instructionResource: ExecutionLogicResource

@onready var typeLabel: Label = $InstructionExe/Type

signal exitCode

@onready var variableCreationScene : PackedScene = load("res://scenes/UI/commands/executions/variable_creation.tscn")
@onready var colorPickingScene : PackedScene = load("res://scenes/UI/commands/executions/color_picking.tscn")
@onready var variableUpdateScene : PackedScene = load("res://scenes/UI/commands/executions/variable_update.tscn")
@onready var functionCallScene : PackedScene = load("res://scenes/UI/commands/executions/function_call.tscn")
@onready var setCursorPosScene : PackedScene = load("res://scenes/UI/commands/executions/set_cursor_position.tscn")


@onready var specialNode: Control = $InstructionExe/Special

func getSpecialNode():
	return specialNode.get_child(0)

func _ready():
	buildFromResource()

#func retrieveCommand() -> Array[Instruction.InstructionType]:
	#return []

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func buildFromResource():
	if(!instructionResource): return
	
	typeLabel.text = instructionResource.getName()
	
	if instructionResource is CreateLogicResource:
		var argsInstance = variableCreationScene.instantiate()
		argsInstance.creation = instructionResource
		specialNode.add_child(argsInstance)
	elif instructionResource is ChangeColorLogicResource:
		var argsInstance = colorPickingScene.instantiate()
		argsInstance.colorLogic = instructionResource
		specialNode.add_child(argsInstance)
	elif instructionResource is UpdateLogicResource:
		var argsInstance = variableUpdateScene.instantiate()
		argsInstance.update = instructionResource
		specialNode.add_child(argsInstance)
	elif instructionResource is CallFunctionLogicResource:
		var argsInstance = functionCallScene.instantiate()
		argsInstance.functionCall = instructionResource
		specialNode.add_child(argsInstance)
	elif  instructionResource is SetCursorPositionLogicResource:
		var argsInstance = setCursorPosScene.instantiate()
		argsInstance.cursor_position = instructionResource
		specialNode.add_child(argsInstance)


func _get_drag_data(at_position: Vector2) -> Variant:
	var title: Label = Label.new()
	title.text = instructionResource.getName()
	set_drag_preview(title)
	emit_signal("exitCode")
	return instructionResource


func _on_mouse_entered() -> void:
	$InstructionExe/CenterContainer/Delete.visible = true


func _on_mouse_exited() -> void:
	$InstructionExe/CenterContainer/Delete.visible = false
