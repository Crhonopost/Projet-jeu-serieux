extends Control

var variable : ExpressionResource = VariableExpressionResource.new()
@export var replaceOnDrop := false

signal stateChanged(variable: ExpressionResource)

var nameLabel: Label

func _ready() -> void:
	if(variable is VariableExpressionResource):
		setVariableMode(variable)
	else:
		setOperationMode(variable)

func onVariableChange(newVal):
	nameLabel.text = str(newVal)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is ExpressionResource

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if((data is VariableExpressionResource && variable.value is int) || replaceOnDrop):
		setVariableMode(data)
	elif(data is VariableExpressionResource):
		var newExpr = OperationResource.new()
		newExpr.variableA = variable
		newExpr.variableB = data
		setOperationMode(newExpr)
	elif(data is OperationResource):
		setOperationMode(data)

func _get_drag_data(at_position: Vector2) -> Variant:
	if(variable != null):
		variable.disconnect("valueChanged", onVariableChange)
		var title := Label.new()
		title.text = str(variable)
		set_drag_preview(title)
		
		var res = variable
		setVariableMode(VariableExpressionResource.new())
		return res
	else:
		return null


func clearChildren():
	for c in $HBoxContainer.get_children():
		c.queue_free()

func setVariableMode(varExpr : VariableExpressionResource):
	clearChildren()
	variable = varExpr
	
	if(variable.value is String):
		var label = Label.new()
		label.text = str(variable.value)
		nameLabel = label
		$HBoxContainer.add_child(label)
	else:
		var input = SpinBox.new()
		input.value = variable.value
		input.get_line_edit().set_drag_forwarding(_get_drag_data, _can_drop_data, _drop_data)
		input.connect("value_changed", _on_input_value_changed)
		$HBoxContainer.add_child(input)
	
	emit_signal("stateChanged", variable)
	variable.connect("valueChanged", onVariableChange)

func setOperationMode(opExpr: OperationResource):
	clearChildren()
	variable = opExpr

	var hbox = HBoxContainer.new()
	add_child(hbox)

	var left_input = preload("res://scenes/UI/commands/var_drop_slot.tscn").instantiate()
	var right_input = preload("res://scenes/UI/commands/var_drop_slot.tscn").instantiate()
	
	var op_label = Label.new()
	op_label.text = LowLevelExpression.operatorToStr(opExpr.operator)

	hbox.add_child(left_input)
	hbox.add_child(op_label)
	hbox.add_child(right_input)

	left_input.connect("stateChanged", func(e): opExpr.variableA = e)
	right_input.connect("stateChanged", func(e): opExpr.variableB = e)

	if opExpr.variableA:
		left_input._drop_data(Vector2.ZERO, opExpr.variableA)
	if opExpr.variableB:
		right_input._drop_data(Vector2.ZERO, opExpr.variableB)

	emit_signal("stateChanged", variable)


func _on_input_value_changed(value: float) -> void:
	variable.value = value
	emit_signal("stateChanged", variable)
