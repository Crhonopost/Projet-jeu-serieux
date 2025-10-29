extends Control

@export var edited_function: FunctionLogicResource


func edit_function(function: FunctionLogicResource):
	edited_function = function
	for child in $MarginContainer/VBoxContainer/ScrollContainer/Code.get_children():
		child.queue_free()
	
	$MarginContainer/VBoxContainer/ScrollContainer/Code.add_child(InstructionVisualBuilder.instantiate(function))
	$MarginContainer/VBoxContainer/FunctionName.text = function.name
	
	
	call_deferred("createArgUI", 0, edited_function.args.size())


func _on_add_pressed() -> void:
	edited_function.addArg()
	createArgUI(edited_function.args.size() - 1, 1)

func createArgUI(startingIdx:int, count : int):
	for i in range(count):
		var argUI := LineEdit.new()
		var lastIdx: int = startingIdx + i
		argUI.text = edited_function.args.get(lastIdx)
		argUI.connect("text_submitted", func (name: String): edited_function.args[lastIdx] = name )
		$MarginContainer/VBoxContainer/ArgumentsEdition/Arguments.add_child(argUI)


func _on_delete_pressed() -> void:
	var argIdx = $MarginContainer/VBoxContainer/ArgumentsEdition/Arguments.get_child_count() - 1
	$MarginContainer/VBoxContainer/ArgumentsEdition/Arguments.get_child(argIdx).queue_free()
	edited_function.deleteArg(argIdx)
