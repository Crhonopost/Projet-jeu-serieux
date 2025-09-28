extends Control

@onready var compiler := $Compiler 
@onready var entryPoint := $EntryPoint

@export var entryInstruction : FlowInstructionResource

signal launch

func _ready() -> void:
	entryPoint.instructionResource = entryInstruction
	entryPoint.buildFromResource()


func _on_button_pressed() -> void:
	emit_signal("launch")

func retrieveInstructions() -> Array[Instruction]:
	return compiler.processInstructions(entryPoint.instructionResource)
