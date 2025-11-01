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
	elif(instructionResource is ForLogicResource):
		$PanelTitle/HBoxContainer/For.visible = true
		$PanelTitle/HBoxContainer/For/VariableName.text = instructionResource.variableName
		$PanelTitle/HBoxContainer/For/InitValue.text = instructionResource.stepCount
	
	instantiateList()
	

func instantiateList():
	for instructionChild in instructionResource.childs:
		instantiateChild(instructionChild)

func instantiateChild(instructionChild: LogicResource, index: int = -1):
	var instance = InstructionVisualBuilder.instantiate(instructionChild)
	instance.connect("exitCode", func (): childLeave(instructionChild))
	instructionList.add_child(instance)
	if(index > -1):
		instructionList.move_child(instance, index)

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func childLeave(logicRes: LogicResource):
	for child in instructionList.get_children():
		if child.instructionResource == logicRes:
			child.queue_free()
	instructionResource.childs.erase(logicRes)

func _get_drag_data(at_position: Vector2) -> Variant:
	var title: Label = Label.new()
	title.text = instructionResource.getName()
	set_drag_preview(title)
	emit_signal("exitCode")
	return instructionResource

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var target_idx = instructionResource.childs.size()
	for i in instructionList.get_child_count():
		var child = instructionList.get_child(i)
		var child_mid = child.position.y + child.size.y * 0.5 + $PanelTitle.size.y
		if at_position.y < child_mid && target_idx > i:
			target_idx = i
	
	instructionResource.childs.insert(target_idx, data)
	instantiateChild(data, target_idx)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is LogicResource


func _on_condition_text_changed(new_text: String) -> void:
	instructionResource.condition = new_text


func _on_variable_name_text_changed(new_text: String) -> void:
	instructionResource.variableName = new_text


func _on_init_value_text_changed(new_text: String) -> void:
	instructionResource.stepCount = new_text
