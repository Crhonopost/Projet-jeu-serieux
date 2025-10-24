extends HBoxContainer

var creation := CreateLogicResource.new()

func _ready() -> void:
	$Name.text = str(creation.name)
	$InitialValue.text = str(creation.value)

func _on_initial_value_text_changed(new_text: String) -> void:
	creation.value = new_text


func _on_name_text_changed(new_text: String) -> void:
	creation.name = new_text
