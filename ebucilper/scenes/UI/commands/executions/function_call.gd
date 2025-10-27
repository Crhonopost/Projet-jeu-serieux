extends HBoxContainer

@onready var argUIScene : PackedScene = load("res://scenes/UI/commands/functions/argument_ui.tscn")

var connectedFunction: FunctionLogicResource
var functionCall := CallFunctionLogicResource.new()

signal connectToFunction(index: int)

func _on_function_idx_value_changed(value: float) -> void:
	emit_signal("connectToFunction", int(value))

func linkWithFunctionRes(fnc: FunctionLogicResource):
	if(connectedFunction != null && connectedFunction.is_connected("updateArgsCount", argCountUpdated)):
		connectedFunction.disconnect("updateArgsCount", argCountUpdated)
	
	fnc.connect("updateArgsCount", argCountUpdated)
	for child in $Arguments.get_children():
		child.queue_free()
	connectedFunction = fnc
	argCountUpdated(fnc.args.size())
	
	functionCall.targetFunction = fnc


func argCountUpdated(newCount: int):
	var diff = newCount -  $Arguments.get_child_count()
	if diff > 0:
		for i in range(diff):
			var input = argUIScene.instantiate()
			var correctIdx = connectedFunction.args.size() - diff
			input.connect("expressionUpdated", func (newText: String): changeArgVar(correctIdx, newText))
			input.set_arg_name(connectedFunction.args[correctIdx])
			
			$Arguments.add_child(input)
			functionCall.args.append("")
	elif diff < 0:
		var childs = $Arguments.get_children()
		for i in range(-diff):
			childs[childs.size() - 1 - i].queue_free()
			functionCall.args.remove_at(functionCall.args.size() - 1)

func changeArgVar(idx: int, newName: String):
	functionCall.args[idx] = newName
