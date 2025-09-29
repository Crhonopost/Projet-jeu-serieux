extends Control

var variable: VariableResource
var content

func _enter_tree() -> void:
	variable = VariableResource.new()

signal stateChanged

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is VariableResource:
		return true
	else:
		return false
		
func _drop_data(at_position: Vector2, data: Variant) -> void:
	variable = data
	$Name.text = data.name
	setVariableMode(true)
	emit_signal("stateChanged")

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		var text := Label.new()
		text.text = variable.name
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

func _on_input_text_changed(new_text: String) -> void:
	content = new_text
	emit_signal("stateChanged")

func setVariable(value: Variant) -> void:
	if(value is String):
		variable.name = value
		$Name.text = value
		setVariableMode(true)
	else:
		content = value
		$Input.text = str(value)
		setVariableMode(false)
