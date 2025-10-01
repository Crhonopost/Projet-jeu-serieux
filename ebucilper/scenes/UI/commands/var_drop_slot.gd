extends Control

var variable

signal stateChanged(variable)

func _ready() -> void:
	$Input.get_line_edit().set_drag_forwarding(_get_drag_data, _can_drop_data, _drop_data)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is String

func _drop_data(at_position: Vector2, data: Variant) -> void:
	setVariableMode(true)
	variable = data
	$Name.text = variable
	emit_signal("stateChanged", variable)

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		var title := Label.new()
		title.text = str(variable)
		set_drag_preview(title)
		
		var res = variable
		variable = 0_
		setVariableMode(false)
		emit_signal("stateChanged", variable)
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
		$Input.value = variable

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
	emit_signal("stateChanged", variable)
