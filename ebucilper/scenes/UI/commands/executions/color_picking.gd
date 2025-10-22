extends HBoxContainer

var colorLogic : ChangeColorLogicResource

func _on_item_list_item_selected(index: int) -> void:
	colorLogic.color = index + 1
