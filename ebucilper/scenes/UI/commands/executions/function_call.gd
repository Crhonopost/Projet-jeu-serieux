extends HBoxContainer

var connectedFunction: FunctionLogicResource
var functionCall := CallFunctionLogicResource.new()

signal connectToFunction(index: int)

func _on_function_idx_value_changed(value: float) -> void:
	emit_signal("connectToFunction", int(value))

func linkWithFunctionRes(fnc: FunctionLogicResource):
	if(connectedFunction != null && connectedFunction.is_connected("updateArgsCount", argCountUpdated)):
		connectedFunction.disconnect("updateArgsCount", argCountUpdated)
	
	fnc.connect("updateArgsCount", argCountUpdated)
	for child in range(get_child_count()):
		if(child > 0):
			get_child(child).queue_free()
	connectedFunction = fnc
	argCountUpdated(fnc.args.size())
	
	functionCall.targetFunction = fnc


func argCountUpdated(newCount: int):
	var diff = newCount - (get_child_count() - 1) # -1 To avoid deleting range input
	if diff > 0:
		for i in range(diff):
			var lineEdit = LineEdit.new()
			var correctIdx = connectedFunction.args.size() - diff
			lineEdit.name = connectedFunction.args[correctIdx]
			lineEdit.connect("text_submitted",  func (newText: String): changeArgVar(correctIdx, newText))
			add_child(lineEdit)
			functionCall.args.append("")
	elif diff < 0:
		var childs = get_children()
		for i in range(-diff):
			childs[childs.size() - 1 - i].queue_free()
			functionCall.args.remove_at(functionCall.args.size() - 1)

func changeArgVar(idx: int, newName: String):
	functionCall.args[idx] = newName
