extends Control

var instruction : LogicResource

func setInstruction(instruc : LogicResource):
	if(instruc.getName() == "PLACE_BLOCK"):
		$TextureRect.texture = preload("res://Assets/Images/UI/place_block_icon.png")
	$Label.text = instruc.getName()
	$Label.add_theme_font_size_override("font_size", 12)
	instruction = instruc

func _get_drag_data(at_position: Vector2) -> Variant:
	var label = Label.new()
	label.text = instruction.getName()
	set_drag_preview(label)
	
	return instruction.duplicate(true)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return false
