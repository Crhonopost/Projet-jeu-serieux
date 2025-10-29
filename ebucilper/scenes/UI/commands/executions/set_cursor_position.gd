extends HBoxContainer

var cursor_position := SetCursorPositionLogicResource.new()

func _on_x_text_changed(new_text: String) -> void:
	cursor_position.position_x = new_text


func _on_y_text_changed(new_text: String) -> void:
	cursor_position.position_y = new_text


func _on_z_text_changed(new_text: String) -> void:
	cursor_position.position_z = new_text
