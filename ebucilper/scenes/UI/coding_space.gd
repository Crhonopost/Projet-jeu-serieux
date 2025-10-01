extends Control

@onready var compiler := $Compiler 
var entryPoint : Control

@export var entryInstruction : FlowInstructionResource

signal launch

func _ready() -> void:
	setEntryInstruction(entryInstruction)

func setEntryInstruction(entryInstruction : FlowInstructionResource):
	entryPoint = InstructionVisualBuilder.instantiate(entryInstruction)
	$FirstLine.add_child(entryPoint)
	entryPoint.refreshUI()

func _on_button_pressed() -> void:
	emit_signal("launch")

func retrieveInstructions() -> Array[Instruction]:
	return compiler.processInstructions(entryPoint.instructionResource, 0)
