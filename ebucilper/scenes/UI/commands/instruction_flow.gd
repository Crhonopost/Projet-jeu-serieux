class_name InstructionFlowUI extends Control

@export var instructionResource: ListLogicResource

@onready var typeLabel: Label = $PanelTitle/HBoxContainer/Type
@onready var header: HBoxContainer = $PanelTitle/HBoxContainer
@onready var instructionList: VBoxContainer = $PanelInstructions/MarginContainer/SubInstructions
@onready var conditionField = $PanelTitle/HBoxContainer/Condition

signal exitCode

func _ready():
	typeLabel.text = instructionResource.getName()
	
	if(instructionResource is FlowLogicResource):
		conditionField.text = instructionResource.condition
		conditionField.visible = true
	elif(instructionResource is FunctionLogicResource):
		$PanelTitle/HBoxContainer.visible = false
	
	instantiateList()
	

func instantiateList():
	for instructionChild in instructionResource.childs:
		instantiateChild(instructionChild)

func instantiateChild(instructionChild: LogicResource):
	var instance = InstructionVisualBuilder.instantiate(instructionChild)
	instance.connect("exitCode", func (): childLeave(instructionChild))
	instructionList.add_child(instance)

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func childLeave(logicRes: LogicResource):
	for child in instructionList.get_children():
		if child.instructionResource == logicRes:
			child.queue_free()
	instructionResource.childs.erase(logicRes)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	instructionResource.childs.append(data)
	instantiateChild(data)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is LogicResource


func _on_condition_text_changed(new_text: String) -> void:
	instructionResource.condition = new_text
