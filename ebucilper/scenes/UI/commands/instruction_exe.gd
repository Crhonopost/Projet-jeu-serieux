extends Control

@export var instructionResource: ExecutionInstructionResource

@onready var typeLabel: Label = $HBoxContainer/Type

var childsInstances : Array[Node] = []

func _ready():
	buildFromResource()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	queue_free()

func buildFromResource():
	if(!instructionResource): return
	for child in childsInstances:
		child.queue_free()
	
	typeLabel.text = instructionResource.getName()
