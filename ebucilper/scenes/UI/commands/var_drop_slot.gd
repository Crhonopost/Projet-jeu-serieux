extends Control

var variable := VariableResource.new()

signal stateChanged(variable)

func _ready() -> void:
	$Input.get_line_edit().set_drag_forwarding(_get_drag_data, _can_drop_data, _drop_data)
	
func onVariableChange(newVal):
	$Name.text = str(newVal)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is VariableResource && data.value is String

func _drop_data(at_position: Vector2, data: Variant) -> void:
	setVariableMode(true)
	variable = data
	$Name.text = str(variable.value)
	emit_signal("stateChanged", variable)
	variable.connect("valueChanged", onVariableChange)

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		variable.disconnect("valueChanged", onVariableChange)
		var title := Label.new()
		title.text = str(variable.value)
		set_drag_preview(title)
		
		var res = variable
		variable = VariableResource.new()
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
		$Input.value = variable.value

func setVariable(inputVar: VariableResource) -> void:
	variable = inputVar
	if(inputVar.value is String):
		variable = inputVar
		$Name.text = inputVar.value
		setVariableMode(true)
	else:
		$Input.value = inputVar.value
		setVariableMode(false)


func _on_input_value_changed(value: float) -> void:
	variable.value = value
	emit_signal("stateChanged", variable)
