extends Control

var variable

signal stateChanged

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is int or data is String

func _drop_data(at_position: Vector2, data: Variant) -> void:
	variable = data
	$Name.text = data.name
	setVariableMode(true)
	emit_signal("stateChanged")

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		var text := Label.new()
		text.text = variable
		set_drag_preview(text)
		setVariableMode(false)
		
		var res = variable
		variable = null
		emit_signal("stateChanged")
		return res
	else:
		return null
	

func setVariableMode(state: bool):
	if state:
		$Input.visible = false
		$Name.visible = true
	else:
		$Name.visible = false
		$Input.visible = true
		variable = null

func setVariable(value: Variant) -> void:
	variable = value
	if(value is String):
		variable = value
		$Name.text = value
		setVariableMode(true)
	else:
		$Input.value = value
		setVariableMode(false)


func _on_input_value_changed(value: float) -> void:
	variable = value
	emit_signal("stateChanged")
