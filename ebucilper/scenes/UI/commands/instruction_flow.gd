class_name InstructionFlowUI extends Control

@export var instructionResource: ListLogicResource

@onready var typeLabel: Label = $HBoxContainer/Type
@onready var header: HBoxContainer = $HBoxContainer
@onready var instructionList: VBoxContainer = $MarginContainer/SubInstructions
@onready var conditionList: VBoxContainer = $HBoxContainer/Conditions

@onready var conditionScene: PackedScene = load("res://scenes/UI/commands/condition.tscn")

var instructionsDirty = true
var conditionDirty = true

signal exitCode

func _ready():
	refreshUI()

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func refreshUI():
	if(!instructionResource): return
	
	if conditionDirty:
		conditionDirty = false
		for child in conditionList.get_children():
			child.queue_free()
		
		if(instructionResource is FlowLogicResource):
			var conditionInstance = conditionScene.instantiate()
			conditionInstance.condition = instructionResource.condition
			conditionInstance.connect("conditionUpdated", func(condition): 
				instructionResource.condition = condition)
			conditionList.add_child(conditionInstance)
	
	typeLabel.text = instructionResource.getName()
	
	if instructionsDirty:
		instructionsDirty = false
		for child in instructionList.get_children():
			child.queue_free()

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
	instructionsDirty = true
	refreshUI()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is LogicResource
