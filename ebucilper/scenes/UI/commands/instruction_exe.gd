extends Control

@export var instructionResource: ExecutionInstructionResource

@onready var typeLabel: Label = $HBoxContainer/Type

signal exitCode


func _ready():
	buildFromResource()

func retrieveCommand() -> Array[Instruction.InstructionType]:
	return []

func _on_delete_pressed() -> void:
	emit_signal("exitCode")

func buildFromResource():
	if(!instructionResource): return
	
	typeLabel.text = instructionResource.getName()
	
	if instructionResource is CreateInstructionResource:
		$HBoxContainer/Special/VariableCreation.visible = true
		$HBoxContainer/Special/VariableCreation/Name.text = str(instructionResource.name.value)
		$HBoxContainer/Special/VariableCreation/InitialValue.text = str(instructionResource.value)
		
	if instructionResource.type == Instruction.InstructionType.CHANGE_COLOR:
		$HBoxContainer/Special/ColorPick.visible = true


func _get_drag_data(at_position: Vector2) -> Variant:
	var title: Label = Label.new()
	title.text = instructionResource.getName()
	set_drag_preview(title)
	emit_signal("exitCode")
	return instructionResource


func _on_create_var_name_input_text_changed(new_text: String) -> void:
	instructionResource.name.setValue(new_text)
func _on_initial_value_text_changed(new_text: String) -> void:
	instructionResource.value = int(new_text)


func _on_item_list_item_selected(index: int) -> void:
	instructionResource.arguments["color"] = index + 1
