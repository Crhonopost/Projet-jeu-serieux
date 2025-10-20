extends Control

@onready var variableItemScene : PackedScene = load("res://scenes/UI/commands/editor/variable_item.tscn")

@onready var compiler := $Compiler 
var entryPoint : Control

@export var entryInstruction : ListLogicResource

signal launch

func _ready() -> void:
	setEntryInstruction(entryInstruction)
	InstructionVisualBuilder.connect("variableCreationInstantiated", newVariableAdded)

func setEntryInstruction(entryInstruction : ListLogicResource):
	entryPoint = InstructionVisualBuilder.instantiate(entryInstruction)
	$FirstLine.add_child(entryPoint)
	entryPoint.refreshUI()

func _on_button_pressed() -> void:
	emit_signal("launch")

func retrieveInstructions() -> Array[Instruction]:
	return compiler.processInstructions(entryPoint.instructionResource, 0)

func newVariableAdded(variable: VariableExpressionResource):
	var instance = variableItemScene.instantiate()
	instance.variable = variable
	$VariableList.add_child(instance)
