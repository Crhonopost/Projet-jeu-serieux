extends Command

@export var loopCount := 1

var instructionScene : PackedScene = load("res://scenes/UI/commands/command_execution.tscn")

func retrieveCommand() -> Array[InstructionType]:
	var instructions: Array[InstructionType]
	var loopInstructions: Array[InstructionType]
	for child in get_children():
		loopInstructions.append_array(child.retriveCommand())
	
	for i in loopCount:
		instructions.append_array(loopInstructions)
	
	return instructions


func _on_add_pressed() -> void:
	var instance = instructionScene.instantiate()
	$Flow/Instructions.add_child(instance)


func _on_count_value_changed(value: float) -> void:
	loopCount = value
