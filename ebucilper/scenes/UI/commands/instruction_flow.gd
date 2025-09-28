class_name InstructionFlowUI extends Control

@export var instructionResource: FlowInstructionResource

@onready var typeLabel: Label = $VBoxContainer/HBoxContainer/Type
@onready var header: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var instructionList: VBoxContainer = $VBoxContainer/MarginContainer/SubInstructions

signal exitCode

func _ready():
	refreshUI()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func refreshUI():
	if(!instructionResource): return
	for child in instructionList.get_children():
		child.queue_free()
	
	typeLabel.text = instructionResource.getName()
	var childIt = 0
	while(childIt < instructionResource.childs.size()):
		var instance = InstructionVisualBuilder.instantiate(instructionResource.childs[childIt])
		instance.connect("exitCode", func (): childLeave(childIt))
		instructionList.add_child(instance)
		childIt += 1

func childLeave(idx : int):
	instructionResource.childs.remove_at(idx)
	refreshUI()

func _drop_data(at_position: Vector2, data: Variant) -> void:
	instructionResource.childs.append(data)
	refreshUI()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
