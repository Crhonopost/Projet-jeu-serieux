extends HBoxContainer

signal nameUpdated(value: String)


func set_arg_name(text: String) -> void:
	$NameInput.text = text

func _on_name_input_text_submitted(new_text: String) -> void:
	emit_signal("nameUpdated", new_text)
