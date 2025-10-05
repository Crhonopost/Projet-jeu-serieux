extends HBoxContainer

var creation := CreateInstructionResource.new()

func _ready() -> void:
	$Name.text = str(creation.name.value)
	$InitialValue.text = str(creation.value)

func _on_initial_value_text_changed(new_text: String) -> void:
	creation.value = int(new_text)


func _on_name_text_changed(new_text: String) -> void:
	creation.name.setValue(new_text)
