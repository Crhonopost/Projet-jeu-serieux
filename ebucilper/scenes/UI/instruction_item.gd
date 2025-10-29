extends Control

var instruction : LogicResource

func setInstruction(instruc : LogicResource):
	$TextureRect.texture = instruc.getLogo()
	instruction = instruc
	
	tooltip_text = instruction.getName()

func _get_drag_data(at_position: Vector2) -> Variant:
	var label = Label.new()
	label.text = instruction.getName()
	set_drag_preview(label)
	
	return instruction.duplicate(true)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false
