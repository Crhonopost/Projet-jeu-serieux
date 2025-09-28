extends PanelContainer

var instruction : InstructionResource

func setInstruction(instruc : InstructionResource):
	$Label.text = instruc.getName()
	instruction = instruc

func _get_drag_data(at_position: Vector2) -> Variant:
	var label = Label.new()
	label.text = instruction.getName()
	set_drag_preview(label)
	
	return instruction

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false
