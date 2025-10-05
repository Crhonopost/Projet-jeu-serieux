extends HBoxContainer

var color : ExecutionInstructionResource

func _on_item_list_item_selected(index: int) -> void:
	color.arguments["color"] = index + 1
