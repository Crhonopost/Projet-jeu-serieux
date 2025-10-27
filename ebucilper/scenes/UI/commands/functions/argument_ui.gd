extends HBoxContainer

signal expressionUpdated(value: String)


func set_arg_name(text: String) -> void:
	$VariableName.text = text

func _on_expression_input_text_changed(new_text: String) -> void:
	emit_signal("expressionUpdated", new_text)
