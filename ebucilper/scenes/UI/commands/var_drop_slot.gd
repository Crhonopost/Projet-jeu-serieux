extends Control

var variable : String

signal stateChanged(variable: String)

var nameLabel: Label

func _ready() -> void:
	var label = Label.new()
	label.text = str(variable)
	nameLabel = label
	$HBoxContainer.add_child(label)
	
	emit_signal("stateChanged", variable)
	#if !variable.is_connected("valueChanged", onVariableChange):
		#variable.connect("valueChanged", onVariableChange)

func onVariableChange(newVal):
	nameLabel.text = str(newVal)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is String

func _drop_data(at_position: Vector2, data: Variant) -> void:
	nameLabel.text = data
	variable = data

func set_variable(v: String):
	variable = v
	nameLabel.text = variable

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		#variable.disconnect("valueChanged", onVariableChange)
		var title := Label.new()
		title.text = str(variable)
		set_drag_preview(title)
		
		var res = variable
		set_variable("")
		return res
	else:
		return null
