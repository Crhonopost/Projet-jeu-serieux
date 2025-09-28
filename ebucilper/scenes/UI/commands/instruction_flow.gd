class_name InstructionFlowUI extends Control

@export var instructionResource: FlowInstructionResource

@onready var typeLabel: Label = $VBoxContainer/HBoxContainer/Type
@onready var header: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var instructionList: VBoxContainer = $VBoxContainer/MarginContainer/SubInstructions

func _ready():
	refreshUI()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	queue_free()

func refreshUI():
	if(!instructionResource): return
	for child in instructionList.get_children():
		child.queue_free()
	
	typeLabel.text = instructionResource.getName()
	var childIt = 0
	while(childIt < instructionResource.childs.size()):
		var instance = InstructionVisualBuilder.instantiate(instructionResource.childs[childIt])
		instructionList.add_child(instance)
		childIt += 1
