extends Control

@export var instructionResource: ExecutionInstructionResource

@onready var typeLabel: Label = $HBoxContainer/Type

signal exitCode

var childsInstances : Array[Node] = []

func _ready():
	buildFromResource()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func buildFromResource():
	if(!instructionResource): return
	
	typeLabel.text = instructionResource.getName()


func _get_drag_data(at_position: Vector2) -> Variant:
	var title: Label = Label.new()
	title.text = instructionResource.getName()
	set_drag_preview(title)
	emit_signal("exitCode")
	return instructionResource
