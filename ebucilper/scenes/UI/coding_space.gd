extends Control


func _on_execute_pressed() -> void:
	var res: Array[Global.InstructionType]
	for child in $VBoxContainer/Commands.get_children():
		res.append_array(child.retrieveCommand())
	
	print(res)
